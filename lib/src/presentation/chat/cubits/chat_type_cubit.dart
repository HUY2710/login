import '../../../shared/cubit/value_cubit.dart';

enum TypeChat { text, location }

class ChatTypeCubit extends ValueCubit<TypeChat> {
  ChatTypeCubit() : super(TypeChat.text);
}
