import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';

class SendLocationState {
  const SendLocationState({required this.lat, required this.long});
  final double lat;
  final double long;

  SendLocationState copyWith({double? lat, double? long}) =>
      SendLocationState(lat: lat ?? this.lat, long: long ?? this.long);
}

class SendLocationCubit extends ValueCubit<SendLocationState> {
  SendLocationCubit()
      : super(SendLocationState(
          lat: Global.instance.currentLocation.latitude,
          long: Global.instance.currentLocation.latitude,
        ));
  void changeState({required double lat, required double long}) {
    emit(SendLocationState(lat: lat, long: long));
  }
}
