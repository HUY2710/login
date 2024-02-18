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
              child: chats[index].data().content == ''
                  ? buildMessLocation(context)
                  : Text(
                      chats[index].data().content,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          letterSpacing: -0.4),
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

  Column buildMessLocation(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Assets.icons.icShareLocationFill.svg(
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                      MyColors.primary, BlendMode.srcIn)),
            ),
            10.w.horizontalSpace,
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'Current Location',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                  text: "\nYou's location",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400)),
            ])),
          ],
        ),
        10.h.verticalSpace,
        CustomInkWell(
            child: Container(
              width: double.infinity,
              height: 30.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.circular(6.r)),
              child: Text('View Location',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600)),
            ),
            onTap: () {
              context.read<ChatTypeCubit>().update(const ChatTypeState(
                  type: TypeChat.location,
                  lat: 21.188609617609117,
                  long: 05.68341411534462));
            })
      ],
    );
  }
}
