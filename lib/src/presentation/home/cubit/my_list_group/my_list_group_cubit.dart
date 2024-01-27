import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/remote/firestore_client.dart';

part 'my_list_group_state.dart';
part 'my_list_group_cubit.freezed.dart';

@injectable
class MyListGroupCubit extends Cubit<MyListGroupState> {
  MyListGroupCubit() : super(const MyListGroupState.initial());

  List<StoreGroup> _groups = <StoreGroup>[];

  final FirestoreClient _fireStoreClient = FirestoreClient.instance;

  Future<void> fetchMyGroups() async {
    emit(const MyListGroupState.loading());
    final result = await _fireStoreClient.getMyGroups();
    if (result != null && result.isNotEmpty) {
      _groups = result;
      emit(MyListGroupState.success(_groups));
    } else {
      emit(const MyListGroupState.success([]));
    }
  }

  Future<void> deleteGroup(StoreGroup group) async {
    try {
      final status = await _fireStoreClient.deleteGroup(group);
      if (status) {
        _groups.remove(group);
        emit(const MyListGroupState.loading());
        emit(MyListGroupState.success(_groups));
      }
    } catch (error) {
      emit(MyListGroupState.error(error.toString()));
    }
  }
}
