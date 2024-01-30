part of '../chat_screen.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({
    super.key,
    required this.userName,
    required this.message,
    required this.time,
    required this.avatar,
    required this.groupName,
  });

  final String userName;
  final String message;
  final String time;
  final String avatar;
  final String groupName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            isDismissible: false,
            backgroundColor: Colors.white,
            // elevation: 10,
            barrierColor: Colors.black.withOpacity(0.4),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MyDrag(),
                    12.verticalSpace,
                    _buildItemBottomSheet(
                        title: 'Mute', icon: Assets.icons.icMute, click: () {}),
                    _buildItemBottomSheet(
                        title: 'Leave group',
                        icon: Assets.icons.icLoggout,
                        click: () {}),
                    _buildItemBottomSheet(
                        title: 'Delete',
                        icon: Assets.icons.icTrash,
                        click: () {}),
                    12.verticalSpace,
                  ],
                ),
              );
            });
      },
      onTap: () {
        context.pushRoute(
            ChatDetailRoute(storeChatGroups: context.read<GroupCubit>().state));
      },
      child: Container(
        color: Colors.transparent,
        height: 60.h,
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Badge(
                label: Text(
                  '06',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                backgroundColor: MyColors.primary,
                largeSize: 20,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: Image.asset(avatar)),
              ),
            ),
            20.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        groupName,
                        style: TextStyle(
                            color: MyColors.black34,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      6.horizontalSpace,
                      const LinearContainer(
                          child: SizedBox(
                        width: 8,
                        height: 8,
                      ))
                    ],
                  ),
                  Expanded(
                    child: Text(
                      '$userName: $message',
                      style: TextStyle(
                          color: const Color(0xff6C6C6C),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            8.horizontalSpace,
            Text(
              formatDateTime(DateTime.parse(time)),
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
    if (input.isAfter(now) && input.isBefore(now.add(Duration(days: 1)))) {
      return '${input.hour}:${input.minute}';
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
}
