import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/store_group/store_group.dart';
import '../../data/remote/group_manager.dart';
import '../../gen/gens.dart';
import '../../shared/helpers/gradient_background.dart';
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
                  fillColor: Color(0xffEFEFEF),
                  filled: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color(0xff928989),
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.r,
                    color: Color(0xff928989),
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
            GroupItem(),
            FutureBuilder(
                future: ChatSercive.instance.getMyGroupChat(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // logger.d(snapshot.data?.first.lastMessage?.content);
                    // return Text(snapshot.data!.length.toString());
                    return Text('Done');
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}

class GroupItem extends StatelessWidget {
  const GroupItem({
    super.key,
  });

  final String userName = 'Sera';
  final String message =
      'Actually I wanted to check with you about your online about your ';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Image.asset('assets/images/avatars/avatar10.png')),
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
                      'My Planet',
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
            'Jan 16, 2023',
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
}
