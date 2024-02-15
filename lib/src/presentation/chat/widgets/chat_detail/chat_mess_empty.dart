part of '../../chat_detail_screen.dart';

class MessageEmptyScreen extends StatelessWidget {
  const MessageEmptyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/chat/chat_empty.png',
          width: 200.w,
          height: 165.h,
        ),
        Text(
          'No messages here yet...',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          'Send a message to start your \nconversation',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: MyColors.black34),
        ),
      ],
    );
  }
}
