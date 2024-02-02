import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/store_group/store_group.dart';

part 'group_state.freezed.dart';

@freezed
class GroupState with _$GroupState {
  const factory GroupState.initial() = _Initial;

  const factory GroupState.loading() = _Loading;

  const factory GroupState.success(List<StoreGroup> groups) = _Success;

  const factory GroupState.failed(String message) = _Failed;
}
