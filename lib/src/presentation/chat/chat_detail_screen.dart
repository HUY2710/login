import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/store_chat_group/store_chat_group.dart';
import '../../data/models/store_message/store_message.dart';
import '../../data/remote/collection_store.dart';
import '../../gen/gens.dart';
import '../../shared/helpers/logger_utils.dart';
import '../../shared/widgets/custom_inkwell.dart';
import 'cubits/chat_cubit.dart';
import 'services/chat_service.dart';
import 'utils/util.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.storeChatGroups});
  final List<StoreChatGroup> storeChatGroups;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d(widget.storeChatGroups);
    return BlocProvider(
      create: (context) => ChatCubit(),
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
          child: StreamBuilder(
              stream: ChatService.instance
                  .streamMessageGroup('3pj9HcOMuVG5q0bDWgeOlzSt'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chats = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return Utils.checkIsUser(
                                code: chats[index].data().senderId)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 1.sw * 0.7),
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r),
                                            bottomLeft: Radius.circular(15.r),
                                            bottomRight: Utils.checkLastMessage(
                                                    code: chats[index]
                                                        .data()
                                                        .senderId,
                                                    isLastMessage: index ==
                                                        chats.length - 1)
                                                ? Radius.zero
                                                : Radius.circular(15.r)),
                                        color: const Color(0xffB98EFF)),
                                    child: Text(
                                      chats[index].data().content,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          letterSpacing: -0.4),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  // Image.asset(chats[index].data().),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: 1.sw * 0.7),
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r),
                                            bottomLeft: Utils.compareUserCode(
                                                    chats[index - 1]
                                                        .data()
                                                        .senderId,
                                                    chats[index]
                                                        .data()
                                                        .senderId)
                                                ? Radius.zero
                                                : Radius.circular(15.r),
                                            bottomRight: Radius.circular(15.r)),
                                        color: const Color(0xffB98EFF)),
                                    child: Text(
                                      chats[index].data().content,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          letterSpacing: -0.4),
                                    ),
                                  ),
                                ],
                              );
                      });
                }
                return SizedBox();
              }),
        ),
        floatingActionButton: IconButton(
            onPressed: () async {
              CollectionStore.chat
                  .doc('3pj9HcOMuVG5q0bDWgeOlzSt')
                  .collection(CollectionStoreConstant.messages)
                  .add(MessageModel(
                          content:
                              'Hello 0aksjdhaksdh kahsdkjashdka aksd aksjdhakjsdh kjahsd kajsd jahsdka sdj ajshdkaj jhsakdjh 97',
                          senderId: '6dwGCSnO91dGPuzqFfoqKcRK',
                          sentAt: DateTime.now().toString())
                      .toJson());
            },
            icon: Icon(Icons.aspect_ratio)),
      ),
    );
  }
}
