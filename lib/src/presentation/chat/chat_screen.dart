import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/widgets/containers/linear_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/my_drag.dart';
import 'cubits/group_cubit.dart';
import 'cubits/group_state.dart';

part 'widgets/chat_group_empty.dart';
part 'widgets/group_item.dart';
part 'widgets/input_search.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

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
      body: BlocBuilder<GroupCubit, GroupState>(
        bloc: getIt<GroupCubit>(),
        // listener: (context, state) {
        //   state.maybeWhen(
        //     orElse: () {},
        //   );
        // },
        builder: (context, state) {
          return state.maybeWhen(
              initial: () => const GroupChatEmpty(),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              orElse: () => const GroupChatEmpty(),
              success: (groups) {
                return BlocListener<GroupCubit, GroupState>(
                  bloc: getIt<GroupCubit>(),
                  listenWhen: (previous, current) => previous != current,
                  listener: (context, state) {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputSearch(textController: textController),
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
                                final groupItem = groups[index];
                                return GroupItem(
                                  userName: groupItem.storeUser!.userName,
                                  message: (groupItem.lastMessage!.content ==
                                          '')
                                      ? '${groupItem.storeUser!.code == Global.instance.user!.code ? 'You' : groupItem.storeUser!.userName} created group'
                                      : groupItem.lastMessage!.content,
                                  time: groupItem.lastMessage!.sentAt,
                                  avatar: groupItem.avatarGroup,
                                  groupName: groupItem.groupName,
                                  idGroup: groupItem.idGroup ?? '',
                                  seen: groupItem.seen ?? false,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                  color: Color(0xffEAEAEA),
                                );
                              },
                              itemCount: groups.length),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
