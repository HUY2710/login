import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/store_message/store_message.dart';

class ChatCubit extends Cubit<List<MessageModel>?> {
  ChatCubit() : super(null);

  late List<MessageModel> listChat;

  void updateListChat(QuerySnapshot<MessageModel> snapshot) {
    listChat = snapshot.docs.map((e) => e.data()).toList();
    // listChat = temp;
    emit(listChat);
  }
}
