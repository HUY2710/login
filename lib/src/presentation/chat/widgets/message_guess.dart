part of '../chat_detail_screen.dart';

class MessageTypeGuess extends StatelessWidget {
  const MessageTypeGuess({
    super.key,
    required this.chats,
    required this.index,
  });
  final int index;
  final List<QueryDocumentSnapshot<MessageModel>> chats;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!Utils.checkLastMessByUser(index, chats))
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.asset(
              chats[index].data().avatarUrl!,
              width: 32.w,
            ),
          )
        else
          SizedBox(
            width: 32.w,
          ),
        8.w.horizontalSpace,
        Container(
          constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
          margin: EdgeInsets.symmetric(vertical: 2.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: !Utils.checkLastMessByUser(index, chats)
                      ? Radius.zero
                      : Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r)),
              color: const Color(0xffF7F5FA)),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chats[index].data().userName!,
                        style: TextStyle(
                            color: const Color(0xff8E52FF),
                            fontSize: 12.sp,
                            letterSpacing: -0.15),
                      ),
                      40.horizontalSpace,
                    ],
                  ),
                  Text(
                    chats[index].data().content,
                    style: TextStyle(
                        color: MyColors.black34,
                        fontSize: 13.sp,
                        letterSpacing: -0.15),
                  ),
                ],
              ),
              if (!Utils.compareUserCode(index, chats))
                Positioned(
                    right: 0,
                    child: Text(
                      DateFormat('HH:mm').format(
                        DateTime.parse(chats[index].data().sentAt),
                      ),
                      style: TextStyle(
                          color: const Color(0xff6C6C6C),
                          fontSize: 12.sp,
                          letterSpacing: -0.15),
                    ))
            ],
          ),
        ),
      ],
    );
  }
}
