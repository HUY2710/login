import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_sos/store_sos.dart';
import '../../../data/remote/sos_manager.dart';
import '../../../global/global.dart';

part 'sos_cubit.freezed.dart';
part 'sos_state.dart';

@singleton
class SosCubit extends HydratedCubit<SosState> {
  SosCubit() : super(const SosState.loading());

  Timer? _timer;
  final Duration _duration = const Duration(minutes: 10);

  Future<void> toggle() async {
    final bool status = state.maybeWhen(
      orElse: () => false,
      success: (status) => status,
    );
    emit(SosState.success(!status));
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
  Future<void> onChange(Change<SosState> change) async {
    change.nextState.maybeWhen(
      orElse: () => false,
      success: (status) async {
        await _updateStatus(status);

        if (status) {
          //Tắt sos sau 10 phút nếu sos đang được bật
          _timer = Timer(_duration, _turnOff);
        } else {
          _timer?.cancel();
        }
      },
    );

    super.onChange(change);
  }

  void _turnOff() {
    _updateStatus(false);
    //off sos
    Global.instance.user = Global.instance.user!.copyWith(
      sosStore: const StoreSOS(),
    );
    emit(const SosState.success(false));
  }

  Future<void> _updateStatus(bool status) async {
    DateTime? timeLimit;
    if (status) {
      timeLimit = DateTime.now().add(_duration);
    }

    await SosManager.updateSos(
      {
        'sos': status,
        'sosTimeLimit': timeLimit,
      },
    ).then((value) {
      Global.instance.user = Global.instance.user!
          .copyWith(sosStore: StoreSOS(sos: status, sosTimeLimit: timeLimit));
    }).catchError(
      (err) {
        emit(SosState.error(err.toString()));
      },
    );
  }

  @override
  SosState? fromJson(Map<String, dynamic> json) {
    final bool? status = json['sos'] as bool?;
    return SosState.success(status ?? false);
  }

  @override
  Map<String, dynamic>? toJson(SosState state) {
    return state.maybeWhen(
      orElse: () => {'sos': false},
      success: (status) => {'sos': status},
    );
  }
}
