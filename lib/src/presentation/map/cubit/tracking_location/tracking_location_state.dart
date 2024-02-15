part of 'tracking_location_cubit.dart';

@freezed
class TrackingLocationState with _$TrackingLocationState {
  const factory TrackingLocationState.initial() = _Initial;

  const factory TrackingLocationState.loading() = _Loading;

  const factory TrackingLocationState.success(LatLng latLng) = _Success;

  const factory TrackingLocationState.failed(String message) = _Failed;
}
