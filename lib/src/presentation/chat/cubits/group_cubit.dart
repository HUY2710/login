import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../shared/helpers/logger_utils.dart';
import '../services/chat_service.dart';
import 'group_state.dart';

@injectable
class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(const GroupState.initial());

  final ChatService chatService = ChatService.instance;

  final List<StoreGroup> myGroups = [];

  List<String> idsMyGroup = [];
  List<StoreUser> listStoreUser = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userStream;

  // void updateIdMyGroup(List<String> value) {
  //   idsMyGroup = value;
  // }

  Future<void> initStreamUser() async {
    _userStream = chatService.getUser2().listen((user) {
      logger.i(user.docs.first.data());
      if (user.docs.isNotEmpty) {
        final List<MyIdGroup> myListIdGroup =
            user.docs.map((e) => MyIdGroup.fromJson(e.data())).toList();

        idsMyGroup = myListIdGroup.map((e) => e.idGroup).toList();
      }
    });
  }

  Future<void> initStreamGroupChat() async {
    logger.e(idsMyGroup);
    await initStreamUser();
    if (idsMyGroup.isEmpty) {
      emit(const GroupState.initial());
    } else {
      logger.e(idsMyGroup);
      _groupStream = chatService
          .getMyGroupChat2(idsMyGroup)
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (final group in snapshot.docs) {}
        } else {
          emit(const GroupState.initial());
        }
      });
    }
  }
}
