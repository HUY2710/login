part of '../../chat_detail_screen.dart';

class MessageTypeUser extends StatelessWidget {
  const MessageTypeUser({
    super.key,
    required this.chats,
    required this.index,
  });
  final int index;
  final List<QueryDocumentSnapshot<MessageModel>> chats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 1.sw * 0.7),
              margin: EdgeInsets.symmetric(vertical: 2.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Utils.checkLastMessage(
                              code: chats[index].data().senderId,
                              isLastMessage: index == chats.length - 1)
                          ? Radius.zero
                          : Radius.circular(15.r)),
                  color: const Color(0xffB98EFF)),
              child: Text(
                chats[index].data().content,
                style: TextStyle(
                    color: Colors.white, fontSize: 13.sp, letterSpacing: -0.4),
              ),
            ),
          ],
        ),
        if (chats[index].data().senderId == Global.instance.user!.code &&
            index == chats.length - 1)
          Assets.icons.icSendSuccess.svg(width: 16.r),
      ],
    );
  }
}
