import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../gen/gens.dart';
import '../../shared/helpers/logger_utils.dart';
import '../../shared/widgets/containers/linear_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import 'services/chat_service.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30.w,
        leading: CustomInkWell(
            child: SvgPicture.asset(
              'assets/icons/icon_back.svg',
              width: 28.r,
            ),
            onTap: () => context.popRoute()),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  fillColor: const Color(0xffEFEFEF),
                  filled: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: const Color(0xff928989),
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.r,
                    color: const Color(0xff928989),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.sp)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r)),
            ),
            30.h.verticalSpace,
            Text(
              'Group',
              style: TextStyle(
                  color: MyColors.black34,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
            10.h.verticalSpace,
            Expanded(
              child: FutureBuilder(
                  future: ChatService.instance.getMyGroupChat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // logger.d(snapshot.data?.first.lastMessage?.content);
                      // return Text(snapshot.data!.length.toString());
                      if (snapshot.data!.isEmpty) {
                      } else {
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              final groupItem = snapshot.data![index];
                              return GroupItem(
                                userName: groupItem.storeUser!.userName,
                                message: groupItem.lastMessage == null
                                    ? '${groupItem.storeUser!.userName} created group'
                                    : groupItem.lastMessage!.content,
                                time: groupItem.lastMessage!.sentAt,
                                avatar: groupItem.avatarGroup,
                                groupName: groupItem.groupName,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 1,
                                color: Color(0xffEAEAEA),
                              );
                            },
                            itemCount: snapshot.data!.length);
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return SizedBox(
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
    );
  }

  String formatDateTime(DateTime input) {
    final DateTime now = DateTime.now();
    logger.i(input.isAfter(now));
    if (input.isAfter(now) && input.isBefore(now.add(Duration(days: 1)))) {
      // If input is within the current day, display hour and minute
      return '${input.hour}:${input.minute}';
    } else if (input.weekday >= 1 && input.weekday <= 7) {
      // If input represents a day of the week, display the weekday
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
      // Otherwise, display in month, day, year format
      return DateFormat('MMM d, yyyy').format(input);
    }
  }
}
