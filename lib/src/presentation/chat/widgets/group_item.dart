part of '../chat_screen.dart';

class GroupItem extends StatefulWidget {
  const GroupItem({
    super.key,
    required this.userName,
    required this.message,
    required this.time,
    required this.avatar,
    required this.groupName,
    required this.idGroup,
    required this.seen,
    required this.isAdmin,
  });

  final String userName;
  final String message;
  final String time;
  final String avatar;
  final String groupName;
  final String idGroup;
  final bool seen;
  final bool isAdmin;

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> with AutoRouteAwareStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      // onLongPress: () {
      //   showAppModalBottomSheet(
      //       context: context,
      //       isDismissible: false,
      //       backgroundColor: Colors.white,
      //       // elevation: 10,
      //       barrierColor: Colors.black.withOpacity(0.4),
      //       builder: (context) {
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 16),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const Align(child: MyDrag()),
      //               12.verticalSpace,
      //               if (widget.isAdmin)
      //                 _buildItemBottomSheet(
      //                     title: 'Edit group name',
      //                     icon: Assets.icons.icEdit,
      //                     click: () {}),
      //               _buildItemBottomSheet(
      //                   title: 'Mute', icon: Assets.icons.icMute, click: () {}),
      //               _buildItemBottomSheet(
      //                   title: 'Leave group',
      //                   icon: Assets.icons.icLoggout,
      //                   click: () {}),
      //               _buildItemBottomSheet(
      //                   title: 'Delete',
      //                   icon: Assets.icons.icTrash,
      //                   click: () {}),
      //               12.verticalSpace,
      //             ],
      //           ),
      //         );
      //       });
      // },
      onTap: () {
        context.pushRoute(ChatDetailRoute(
          idGroup: widget.idGroup,
          groupName: widget.groupName,
        ));
      },
      child: SizedBox(
        // color: Colors.transparent,
        height: 65.h,
        width: double.infinity,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 52.r,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Image.asset(widget.avatar)),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(
                        widget.groupName,
                        style: TextStyle(
                            color: MyColors.black34,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      6.horizontalSpace,
                      if (widget.seen)
                        const LinearContainer(
                            child: SizedBox(
                          width: 8,
                          height: 8,
                        ))
                      // FutureBuilder(
                      //     future:
                      //         Utils.getSeenMess(widget.idGroup, widget.time),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         const LinearContainer(
                      //             child: SizedBox(
                      //           width: 8,
                      //           height: 8,
                      //         ));
                      //       }
                      //       return SizedBox();
                      //     })
                    ],
                  ),
                  Text(
                    widget.message,
                    style: TextStyle(
                        color: const Color(0xff6C6C6C),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            8.horizontalSpace,
            Text(
              formatDateTime(DateTime.parse(widget.time)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff6C6C6C)),
            ),
          ],
        ),
      ),
    );
  }

  CustomInkWell _buildItemBottomSheet({
    required String title,
    required SvgGenImage icon,
    required Function click,
  }) {
    return CustomInkWell(
      onTap: () => click,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            icon.svg(width: 20.r),
            12.horizontalSpace,
            Text(
              title,
              style: TextStyle(
                  color: icon == Assets.icons.icTrash
                      ? const Color(0xffFF3B30)
                      : MyColors.black34,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  String formatDateTime(DateTime input) {
    final DateTime now = DateTime.now();
    if (isToday(input)) {
      return '${input.hour}:${input.minute < 10 ? '0${input.minute}' : input.minute}';
    } else if (input.weekday == now.weekday) {
      return input.weekday == 1
          ? 'Sun'
          : input.weekday == 2
              ? 'Mon'
              : input.weekday == 3
                  ? 'Tues'
                  : input.weekday == 4
                      ? 'Wed'
                      : input.weekday == 5
                          ? 'Thu'
                          : input.weekday == 6
                              ? 'Fri'
                              : 'Sat';
    } else {
      return DateFormat('MMM d, yyyy').format(input);
    }
  }

  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(now) == dateFormat.format(dateTime);
  }
}
