import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../config/navigation/app_router.dart';
import '../../gen/gens.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/widgets/containers/linear_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/my_drag.dart';
import 'services/chat_service.dart';

part 'widgets/chat_group_empty.dart';
part 'widgets/group_item.dart';

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
            child: Assets.icons.iconBack.svg(width: 28.r),
            onTap: () => context.popRoute()),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder(
            future: ChatService.instance.getMyGroupChat(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const GroupChatEmpty();
                } else {
                  return Column(
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.r, horizontal: 12.r)),
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
                        child: ListView.separated(
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
                            itemCount: snapshot.data!.length),
                      ),
                    ],
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
