part of 'tracking_places_cubit.dart';

@freezed
class TrackingPlacesState with _$TrackingPlacesState {
  const factory TrackingPlacesState.initial() = _Initial;

  const factory TrackingPlacesState.loading() = _Loading;

  const factory TrackingPlacesState.success(List<StorePlace> places) = _Success;

  const factory TrackingPlacesState.failed(String message) = _Failed;
}
