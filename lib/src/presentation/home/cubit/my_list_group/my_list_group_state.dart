part of 'my_list_group_cubit.dart';

@freezed
class MyListGroupState with _$MyListGroupState {
  const factory MyListGroupState.initial() = _Initial;

  const factory MyListGroupState.loading() = _Loading;

  const factory MyListGroupState.success(List<StoreGroup> groups) = _Success;

  const factory MyListGroupState.error(String message) = _Error;
}
