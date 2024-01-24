part of 'location_listen_cubit.dart';

@freezed
class LocationListenState with _$LocationListenState {
  const factory LocationListenState.initial() = _Initial;

  const factory LocationListenState.loading() = _Loading;

  const factory LocationListenState.success(LatLng latLng) = _Success;

  const factory LocationListenState.failed(String message) = _Failed;
}
