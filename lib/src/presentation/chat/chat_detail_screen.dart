import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/store_message/store_message.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/member_manager.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/gradient_text.dart';
import 'cubits/chat_cubit.dart';
import 'services/chat_service.dart';
import 'utils/util.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.idGroup});
  final String idGroup;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<StoreUser> listUser = [];
  late final ScrollController _controller = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final memberOfGroup =
          await MemberManager.getListMemberOfGroup(widget.idGroup);
      final listIdUser = memberOfGroup!.map((e) => e.idUser ?? '').toList();
      listUser = await ChatService.instance.getUserFromListId(listIdUser);

      setState(() {});
    });

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_controller.hasClients) {
  //     _controller.animateTo(_controller.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 300), curve: Curves.linear);
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
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
        body: listUser.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder(
                          stream: ChatService.instance
                              .streamMessageGroup(widget.idGroup, listUser),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return const MessageEmptyScreen();
                              } else {
                                final chats = snapshot.data!.docs;
                                return ListView.builder(
                                    itemCount: chats.length,
                                    controller: _controller,
                                    itemBuilder: (context, index) {
                                      return Utils.checkIsUser(
                                              code:
                                                  chats[index].data().senderId)
                                          ? MessageTypeUser(
                                              chats: chats,
                                              index: index,
                                            )
                                          : MessageTypeGuess(
                                              chats: chats,
                                              index: index,
                                            );
                                    });
                              }
                            }
                            return const SizedBox();
                          }),
                    ),
                  ),
                  12.h.verticalSpace,
                  Container(
                    height: 88.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Color(0xffEAEAEA)))),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff42474C)
                                        .withOpacity(0.3),
                                    blurRadius: 17,
                                  )
                                ]),
                            child: GradientSvg(Assets.icons.icShareLocation
                                .svg(width: 20.r, height: 20.r)),
                          ),
                        ),
                        12.w.horizontalSpace,
                        Expanded(
                            child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(
                                color: const Color(0xff6C6C6C),
                                fontSize: 14.sp),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 12.h),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: const BorderSide(
                                width: 2,
                                color: MyColors.secondPrimary,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: const BorderSide(
                                width: 2,
                                color: MyColors.secondPrimary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: const BorderSide(
                                width: 2,
                                color: MyColors.secondPrimary,
                              ),
                            ),
                          ),
                        )),
                        12.w.horizontalSpace,
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff42474C)
                                        .withOpacity(0.3),
                                    blurRadius: 17,
                                  )
                                ]),
                            child: GradientSvg(Assets.icons.icGallery
                                .svg(width: 20.r, height: 20.r)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        // floatingActionButton: IconButton(
        //     onPressed: () async {
        //       CollectionStore.chat
        //           .doc('AXk8ES5pGz05fbRJJHJBqjvG')
        //           .collection(CollectionStoreConstant.messages)
        //           .add(MessageModel(
        //                   content: 'Mi chào lại tao',
        //                   senderId: 'Joz7Rn8nBZh3sxnwKwaK1WTK',
        //                   sentAt: DateTime.now().toString())
        //               .toJson());
        //     },
        //     icon: Icon(Icons.aspect_ratio)),
      ),
    );
  }
}

class MessageEmptyScreen extends StatelessWidget {
  const MessageEmptyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/chat/chat_empty.png',
          width: 200.w,
          height: 165.h,
        ),
        Text(
          'No messages here yet...',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          'Send a message to start your \nconversation',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: MyColors.black34),
        ),
      ],
    );
  }
}

class MessageTypeGuess extends StatelessWidget {
  const MessageTypeGuess({
    super.key,
    required this.chats,
    required this.index,
  });
  final int index;
  final List<QueryDocumentSnapshot<MessageModel>> chats;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!Utils.checkLastMessByUser(index, chats))
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.asset(
              chats[index].data().avatarUrl!,
              width: 32.w,
            ),
          )
        else
          SizedBox(
            width: 32.w,
          ),
        8.w.horizontalSpace,
        Container(
          constraints: BoxConstraints(maxWidth: 1.sw * 0.6),
          margin: EdgeInsets.symmetric(vertical: 2.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: !Utils.checkLastMessByUser(index, chats)
                      ? Radius.zero
                      : Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r)),
              color: const Color(0xffF7F5FA)),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chats[index].data().userName!,
                        style: TextStyle(
                            color: const Color(0xff8E52FF),
                            fontSize: 12.sp,
                            letterSpacing: -0.15),
                      ),
                      40.horizontalSpace,
                    ],
                  ),
                  Text(
                    chats[index].data().content,
                    style: TextStyle(
                        color: MyColors.black34,
                        fontSize: 13.sp,
                        letterSpacing: -0.15),
                  ),
                ],
              ),
              if (!Utils.compareUserCode(index, chats))
                Positioned(
                    right: 0,
                    child: Text(
                      DateFormat('HH:mm').format(
                        DateTime.parse(chats[index].data().sentAt),
                      ),
                      style: TextStyle(
                          color: const Color(0xff6C6C6C),
                          fontSize: 12.sp,
                          letterSpacing: -0.15),
                    ))
            ],
          ),
        ),
      ],
    );
  }
}

class MessageTypeUser extends StatelessWidget {
  const MessageTypeUser({super.key, required this.chats, required this.index});
  final int index;
  final List<QueryDocumentSnapshot<MessageModel>> chats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 1.sw * 0.7),
              margin: EdgeInsets.symmetric(vertical: 2.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Utils.checkLastMessage(
                              code: chats[index].data().senderId,
                              isLastMessage: index == chats.length - 1)
                          ? Radius.zero
                          : Radius.circular(15.r)),
                  color: const Color(0xffB98EFF)),
              child: Text(
                chats[index].data().content,
                style: TextStyle(
                    color: Colors.white, fontSize: 13.sp, letterSpacing: -0.4),
              ),
            ),
          ],
        ),
        if (chats[index].data().senderId == Global.instance.user!.code &&
            index == chats.length - 1)
          Assets.icons.icSendSuccess.svg(width: 16.r),
      ],
    );
  }
}
