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
  String get _constructUrl => Uri(
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
          'markers': 'color:red|21.188609617609117,105.68341411534462'
        },
      ).toString();

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
        if (chats[index].data().content == '')
          buildMessLocation()
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
    );
  }

  Container buildMessLocation() {
    return Container(
      constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
              bottomLeft: !Utils.checkLastMessByUser(index, chats)
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
          CachedNetworkImage(
            imageUrl: _constructUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "${chats[index].data().userName ?? 'User'}'s location",
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
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
                      style: TextStyle(fontSize: 13.sp),
                    );
                  }
                  return SizedBox();
                }),
          ),
        ],
      ),
    );
  }
}
