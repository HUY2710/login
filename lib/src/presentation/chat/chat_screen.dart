import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_group/store_group.dart';
import '../../data/models/store_member/store_member.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/widgets/containers/linear_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/gradient_text.dart';
import 'cubits/group_cubit.dart';
import 'cubits/group_state.dart';
import 'cubits/search_group_cubit.dart';

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
  void dispose() {
    super.dispose();
    textController.clear();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchGroupCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: CustomInkWell(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Assets.icons.iconBack.svg(),
              ),
              onTap: () => context.popRoute()),
          centerTitle: true,
          title: Text(
            context.l10n.messages,
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
                          12.h.verticalSpace,
                          InputSearch(textController: textController),
                          30.h.verticalSpace,
                          Text(
                            context.l10n.group,
                            style: TextStyle(
                                color: MyColors.black34,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          10.h.verticalSpace,
                          BlocBuilder<SearchGroupCubit, List<StoreGroup>>(
                            builder: (context, searchState) {
                              if (textController.text.isNotEmpty) {
                                if (searchState.isEmpty) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: Center(
                                        child: GradientText(
                                          context.l10n.noGroups,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ));
                                }
                              }
                              return Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      final groupItem =
                                          textController.text.isNotEmpty
                                              ? searchState[index]
                                              : groups[index];
                                      return GroupItem(
                                        userName: groupItem.storeUser!.userName,
                                        message: convertLastMessage(groupItem),
                                        time: groupItem.lastMessage!.sentAt,
                                        avatar: groupItem.avatarGroup,
                                        groupName: groupItem.groupName,
                                        idGroup: groupItem.idGroup ?? '',
                                        seen: groupItem.seen ?? false,
                                        isAdmin: isAdmin(groupItem),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        thickness: 1,
                                        color: Color(0xffEAEAEA),
                                      );
                                    },
                                    itemCount: groups.length),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  String convertLastMessage(StoreGroup group) {
    final String userCode = Global.instance.user!.code;
    final String userName = group.storeUser!.userName;
    final String content = group.lastMessage!.content;

    if (content.isEmpty) {
      if (group.lastMessage!.lat == null || group.lastMessage!.long == null) {
        return (group.storeUser!.code == userCode)
            ? '${context.l10n.you} ${context.l10n.createdGroup}'
            : '$userName ${context.l10n.createGroup}';
      } else {
        return (group.storeUser!.code == userCode)
            ? '${context.l10n.you} ${context.l10n.sendLocation}'
            : '$userName ${context.l10n.createGroup}';
      }
    } else {
      return (group.storeUser!.code == userCode)
          ? '${context.l10n.you}: $content'
          : '$userName: $content';
    }
  }

  bool isAdmin(StoreGroup itemGroup) {
    if (itemGroup.storeMembers != null && Global.instance.user != null) {
      if (itemGroup.storeMembers!
          .firstWhere(
            (element) => element.idUser == Global.instance.user!.code,
            orElse: () => const StoreMember(isAdmin: false),
          )
          .isAdmin) {
        return true;
      }
      return false;
    }
    return false;
  }
}
