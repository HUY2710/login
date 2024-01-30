import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../config/navigation/app_router.dart';
import '../../data/models/store_user/store_user.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/helpers/logger_utils.dart';
import '../../shared/widgets/containers/linear_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/my_drag.dart';
import 'cubits/group_cubit.dart';
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
  late List<String> idsMyGroup = [];
  late List<StoreUser> listStoreUser = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      idsMyGroup = await ChatService.instance.getIdsMyGroup() ?? [];
      final listIdUser =
          await ChatService.instance.getListIdUserFromLastMessage();
      listStoreUser = await ChatService.instance.getUserFromListId(listIdUser);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(),
      child: Scaffold(
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
          child: (idsMyGroup.isNotEmpty && listStoreUser.isNotEmpty)
              ? StreamBuilder(
                  stream: ChatService.instance
                      .getMyGroupChat(idsMyGroup, listStoreUser),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
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
                                      borderRadius:
                                          BorderRadius.circular(12.sp)),
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
                                    final groupItem =
                                        snapshot.data!.docs[index].data();
                                    logger.e(Global.instance.user!.code);
                                    return GroupItem(
                                      userName: groupItem.storeUser!.userName,
                                      message: (groupItem
                                                  .lastMessage!.content ==
                                              '')
                                          ? '${groupItem.storeUser!.code == Global.instance.user!.code ? 'You' : groupItem.storeUser!.userName} created group'
                                          : groupItem.lastMessage!.content,
                                      time: groupItem.lastMessage!.sentAt,
                                      avatar: groupItem.avatarGroup,
                                      groupName: groupItem.groupName,
                                      idGroup: groupItem.idGroup ?? '',
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 1,
                                      color: Color(0xffEAEAEA),
                                    );
                                  },
                                  itemCount: snapshot.data!.docs.length),
                            ),
                          ],
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
