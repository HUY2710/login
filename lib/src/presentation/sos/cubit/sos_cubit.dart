import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_sos/store_sos.dart';
import '../../../data/remote/sos_manager.dart';
import '../../../global/global.dart';
import '../../map/cubit/my_marker_cubit.dart';

@singleton
class SosCubit extends HydratedCubit<bool> {
  SosCubit() : super(false);

  Timer? _timer;
  final Duration _duration = const Duration(minutes: 10);

  Future<void> toggle() async {
    emit(!state);
  }

  void update(bool status) {
    emit(status);
  }

  Future<void> init() async {
    final bool status = Global.instance.user?.sosStore?.sos ?? false;

    final DateTime now = DateTime.now();
    final DateTime timeLimit =
        Global.instance.user?.sosStore?.sosTimeLimit ?? now;
    final int difference = timeLimit.difference(now).inSeconds;

    //Nếu thời gian hiện tại vượt quá sosTimeLimit, tắt sos
    //nếu không hẹn giờ sau khoảng thời gian [difference] sẽ tắt sos
    if (status && difference <= 0) {
      _turnOff();
    } else {
      _timer = Timer(Duration(seconds: difference), _turnOff);
    }
  }

  @override
  Future<void> onChange(Change<bool> change) async {
    await _updateStatus(change.nextState);

    if (change.nextState) {
      //Tắt sos sau 10 phút nếu sos đang được bật
      _timer = Timer(_duration, _turnOff);
    } else {
      _timer?.cancel();
    }

    super.onChange(change);
  }

  void _turnOff() {
    _updateStatus(false);
    //off sos
    Global.instance.user = Global.instance.user!.copyWith(
      sosStore: const StoreSOS(),
    );
    emit(false);
  }

  Future<void> _updateStatus(bool status) async {
    DateTime? timeLimit;
    if (status) {
      timeLimit = DateTime.now().add(_duration);
    }
    getIt<MyMarkerCubit>().update(
      Global.instance.user?.copyWith(
        sosStore: StoreSOS(
          sos: status,
          sosTimeLimit: timeLimit,
        ),
      ),
    );
    await SosManager.updateSos(
      {
        'sos': status,
        'sosTimeLimit': timeLimit,
      },
    ).then((value) {
      Global.instance.user = Global.instance.user!
          .copyWith(sosStore: StoreSOS(sos: status, sosTimeLimit: timeLimit));
    }).catchError(
      (err) {},
    );
  }

  @override
  bool? fromJson(Map<String, dynamic> json) {
    final bool? status = json['sos'] as bool?;
    return status ?? false;
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {'sos': state};
  }
}
