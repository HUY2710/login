import '../../../shared/cubit/value_cubit.dart';

enum TypeChat { text, location }

class ChatTypeState {
  const ChatTypeState({required this.type, this.lat, this.long});
  final double? lat;
  final double? long;
  final TypeChat type;

  ChatTypeState copyWith({double? lat, double? long, TypeChat? type}) =>
      ChatTypeState(
          lat: lat ?? this.lat,
          long: long ?? this.long,
          type: type ?? this.type);
}

class ChatTypeCubit extends ValueCubit<ChatTypeState> {
  ChatTypeCubit() : super(const ChatTypeState(type: TypeChat.text));
}
