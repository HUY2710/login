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
    final item = chats[index].data();
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
                              code: item.senderId, isLastMessage: index == 0)
                          ? Radius.zero
                          : Radius.circular(15.r)),
                  color: const Color(0xffB98EFF)),
              child: item.content == ''
                  ? buildMessLocation(context, item)
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
        if (item.senderId == Global.instance.user!.code &&
            index == chats.length - 1)
          Assets.icons.icSendSuccess.svg(width: 16.r),
      ],
    );
  }

  Column buildMessLocation(BuildContext context, MessageModel item) {
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
            Expanded(
              child: FutureBuilder(
                  future: LocationService().getCurrentAddress(LatLng(
                      item.lat ?? Global.instance.currentLocation.latitude,
                      item.long ?? Global.instance.currentLocation.longitude)),
                  builder: (context, address) {
                    if (address.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.messageType == MessageType.location)
                            Text(
                                "${item.userName}'s ${context.l10n.location.toLowerCase()}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          if (item.messageType == MessageType.checkIn)
                            Text("${item.userName}'s ${context.l10n.checked}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          Text('${address.data}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400))
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
            ),
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
              child: Text(context.l10n.viewLocation,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600)),
            ),
            onTap: () {
              context.router.replaceAll([
                HomeRoute(latLng: {
                  'lat': item.lat ?? Global.instance.currentLocation.latitude,
                  'lng': item.long ?? Global.instance.currentLocation.longitude
                })
              ], updateExistingRoutes: false);
            })
      ],
    );
  }
}
