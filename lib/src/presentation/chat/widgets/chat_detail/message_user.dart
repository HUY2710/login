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
              padding: item.messageType == MessageType.image
                  ? null
                  : EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  borderRadius: item.messageType == MessageType.image
                      ? BorderRadius.circular(15.r)
                      : BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          topRight: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Utils.checkLastMessage(
                                  code: item.senderId,
                                  isLastMessage: index == 0)
                              ? Radius.zero
                              : Radius.circular(15.r)),
                  color: const Color(0xffB98EFF)),
              child: switch (item.messageType) {
                MessageType.location => buildMessLocation(context, item),
                MessageType.text => buildMessText(context, item),
                MessageType.image => buildMessImage(context, item),
                _ => const SizedBox()
              },
            ),
          ],
        ),
        if (item.senderId == Global.instance.user!.code && index == 0)
          Assets.icons.icSendSuccess.svg(width: 16.r),
      ],
    );
  }

  Text buildMessText(BuildContext context, MessageModel item) {
    return Text(
      item.content,
      style:
          TextStyle(color: Colors.white, fontSize: 13.sp, letterSpacing: -0.4),
    );
  }

  Widget buildMessImage(BuildContext context, MessageModel item) {
    return CustomInkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (contex) {
              return Material(
                color: Colors.black.withOpacity(.4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        imageUrl: item.imagUrl ??
                            'https://cdn.pixabay.com/photo/2017/02/12/21/29/false-2061132_960_720.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    buildButtonClose(context)
                  ],
                ),
              );
            });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: CachedNetworkImage(
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          imageUrl: item.imagUrl ??
              'https://cdn.pixabay.com/photo/2017/02/12/21/29/false-2061132_960_720.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Align buildButtonClose(BuildContext context) {
    return Align(
      alignment: const Alignment(0.9, -0.95),
      child: CustomInkWell(
          child: Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.2), shape: BoxShape.circle),
            child: Icon(
              Icons.close,
              size: 18.r,
              color: Colors.white,
            ),
          ),
          onTap: () => context.popRoute()),
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
