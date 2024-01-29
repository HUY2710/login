import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/store_message/store_message.dart';

class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super([]);
}
