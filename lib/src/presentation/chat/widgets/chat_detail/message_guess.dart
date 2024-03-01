part of '../../chat_detail_screen.dart';

class MessageTypeGuess extends StatelessWidget {
  const MessageTypeGuess({
    super.key,
    required this.chats,
    required this.index,
  });
  final int index;
  final List<QueryDocumentSnapshot<MessageModel>> chats;
  //DATA LATLONG FAKE
  String _constructUrl(double lat, double long) {
    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: {
        'center': '21.188609617609117,105.68341411534462',
        'zoom': '16',
        'size': '400x400',
        'maptype': 'roadmap',
        'key': AppConstants.apiMapKey,
        'markers': 'color:red|$lat,$long'
      },
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final item = chats[index].data();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (Utils.checkLastMessByUser(index, chats))
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.asset(
              item.avatarUrl!,
              width: 32.w,
            ),
          )
        else
          SizedBox(
            width: 32.w,
          ),
        8.w.horizontalSpace,
        if (item.content == '')
          buildMessLocation(context, item)
        else
          buildMessText(),
      ],
    );
  }

  Container buildMessText() {
    return Container(
      constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
              bottomLeft: Utils.checkLastMessByUser(index, chats)
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
                  SizedBox(
                    width: 1.sw * 0.4,
                    child: Text(
                      chats[index].data().userName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xff8E52FF),
                          fontSize: 12.sp,
                          letterSpacing: -0.15),
                    ),
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
    );
  }

  Widget buildMessLocation(BuildContext context, MessageModel item) {
    return CustomInkWell(
      onTap: () {
        context.router.replaceAll([
          HomeRoute(latLng: {
            'lat': item.lat ?? Global.instance.currentLocation.latitude,
            'lng': item.long ?? Global.instance.currentLocation.longitude
          })
        ], updateExistingRoutes: false);
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
        margin: EdgeInsets.symmetric(vertical: 2.h),
        // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
                bottomLeft: Utils.checkLastMessByUser(index, chats)
                    ? Radius.zero
                    : Radius.circular(15.r),
                bottomRight: Radius.circular(15.r)),
            color: const Color(0xffF7F5FA)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chats[index].data().userName ?? 'User',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: MyColors.primary,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(
                      DateTime.parse(chats[index].data().sentAt),
                    ),
                    style: TextStyle(
                        color: const Color(0xff6C6C6C),
                        fontSize: 12.sp,
                        letterSpacing: -0.15),
                  )
                ],
              ),
            ),
            if (getIt<MyPurchaseManager>().state.isPremium())
              CachedNetworkImage(
                imageUrl: _constructUrl(
                    item.lat ?? Global.instance.currentLocation.latitude,
                    item.long ?? Global.instance.currentLocation.longitude),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            else
              ClipRRect(
                child: Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Assets.images.mapEx.image(),
                    ),
                    Positioned(
                      top: 8.h,
                      left: 12.w,
                      child: CustomInkWell(
                        onTap: () => context.pushRoute(PremiumRoute()),
                        child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Assets.icons.premium.icPremiumSvg.svg()),
                      ),
                    )
                  ],
                ),
              ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: (item.messageType == MessageType.location)
                  ? Text(
                      "${chats[index].data().userName ?? 'User'}'s location",
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600),
                    )
                  : Text(
                      "${chats[index].data().userName ?? 'User'}'s checked",
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h, left: 12.w, right: 12.w),
              child: FutureBuilder<String>(
                  future: LocationService().getCurrentAddress(LatLng(
                      chats[index].data().lat!, chats[index].data().long!)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data?.trimLeft() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp),
                      );
                    }
                    return const SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
