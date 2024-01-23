part of 'tracking_member_cubit.dart';

@freezed
class TrackingMemberState with _$TrackingMemberState {
  const factory TrackingMemberState.initial() = _Initial;

  const factory TrackingMemberState.loading() = _Loading;

  const factory TrackingMemberState.success(List<StoreUser> members) = _Success;

  const factory TrackingMemberState.failed(String message) = _Failed;
}
