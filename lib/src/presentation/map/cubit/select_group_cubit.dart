import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_member/store_member.dart';
import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';

@singleton
class SelectGroupCubit extends ValueCubit<StoreGroup?> with HydratedMixin {
  SelectGroupCubit() : super(null) {
    hydrate();
  }

  void removeMember(String idUser) {
    if (state?.storeMembers != null) {
      final List<StoreMember> updatedMembers = List.from(state!.storeMembers!);
      updatedMembers.removeWhere((member) => member.idUser == idUser);
      emit(state!.copyWith(storeMembers: updatedMembers));
    }
  }

  @override
  StoreGroup? fromJson(Map<String, dynamic> json) {
    if (json['currentGroup'] != null) {
      final currentGroup = StoreGroup.fromJson(json['currentGroup']);
      Global.instance.group = currentGroup;
      return currentGroup;
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(StoreGroup? state) {
    return {
      'currentGroup': state,
    };
  }
}
