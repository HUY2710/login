import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/store_message/store_message.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/collection_store.dart';
import '../../data/remote/member_manager.dart';
import '../../gen/gens.dart';
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
  final ScrollController _controller = ScrollController();

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
                          stream: ChatService.instance.streamMessageGroup(
                              '3pj9HcOMuVG5q0bDWgeOlzSt', listUser),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final chats = snapshot.data!.docs;
                              return ListView.builder(
                                  itemCount: chats.length,
                                  controller: _controller,
                                  itemBuilder: (context, index) {
                                    return Utils.checkIsUser(
                                            code: chats[index].data().senderId)
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
                            return const SizedBox();
                          }),
                    ),
                  ),
                  12.h.verticalSpace,
                  Container(
                    height: 88.h,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: Color(0xffEAEAEA)))),
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
                              borderSide: BorderSide(
                                width: 2,
                                color: MyColors.secondPrimary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide(
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
        floatingActionButton: IconButton(
            onPressed: () async {
              CollectionStore.chat
                  .doc('3pj9HcOMuVG5q0bDWgeOlzSt')
                  .collection(CollectionStoreConstant.messages)
                  .add(MessageModel(
                          content: '97',
                          senderId: '6dwGCSnO91dGPuzqFfoqKcRK',
                          sentAt: DateTime.now().toString())
                      .toJson());
            },
            icon: Icon(Icons.aspect_ratio)),
      ),
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
          child: Column(
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
                  if (!Utils.compareUserCode(chats[index - 1].data().senderId,
                      chats[index].data().senderId))
                    Text(
                      DateFormat('HH:mm').format(
                        DateTime.parse(chats[index].data().sentAt),
                      ),
                      style: TextStyle(
                          color: const Color(0xff6C6C6C),
                          fontSize: 12.sp,
                          letterSpacing: -0.15),
                    )
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
    return Row(
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
    );
  }
}
