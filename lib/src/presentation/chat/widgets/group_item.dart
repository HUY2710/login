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
      onTap: () {
        context.pushRoute(ChatDetailRoute(
          idGroup: widget.idGroup,
          groupName: widget.groupName,
        ));
      },
      child: SizedBox(
        height: 75.h,
        width: double.infinity,
        child: Row(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  4.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.groupName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.black34,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      6.horizontalSpace,
                      if (widget.seen)
                        const LinearContainer(
                            child: SizedBox(
                          width: 8,
                          height: 8,
                        ))
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

  String formatDateTime(DateTime input) {
    final languageCode = getIt<LanguageCubit>().state.languageCode;
    return timeago.format(input, locale: languageCode);
  }

  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(now) == dateFormat.format(dateTime);
  }
}
