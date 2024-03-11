import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../app/cubit/exception/exception_cubit.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';

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

  Future<void> leaveGroup({
    required StoreGroup group,
    String? idUser,
    required ExceptionCubit exceptionCubit,
    required BuildContext context,
  }) async {
    try {
      //nếu idUser!=null  => admin xóa
      //nếu idUser==null => mình tự thoát nhóm
      await _fireStoreClient.leaveGroup(
          group.idGroup!, idUser ?? Global.instance.user!.code);
      _groups.remove(group);
      emit(const MyListGroupState.loading());
      emit(MyListGroupState.success(_groups));
      exceptionCubit.success('Leave group success');
    } catch (error) {
      exceptionCubit.error('Không thể rời nhóm');
      debugPrint('error:$error');
    }
  }

  void updateItemGroup(StoreGroup group, int index) {
    try {
      _groups[index] = group;
      emit(const MyListGroupState.loading());
      emit(MyListGroupState.success(_groups));
    } catch (error) {
      emit(MyListGroupState.error(error.toString()));
    }
  }
}
