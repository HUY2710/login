import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/store_chat_group/store_chat_group.dart';

class GroupCubit extends Cubit<List<StoreChatGroup>> {
  GroupCubit() : super([]);

  final List<StoreChatGroup> result = [];

  void update(List<StoreChatGroup> list) {
    result.addAll(list);
    emit(result);
  }
}
