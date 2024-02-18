part of '../../chat_detail_screen.dart';

class ChatTextWidget extends StatefulWidget {
  const ChatTextWidget({
    super.key,
    required this.idGroup,
    required this.listUser,
    required this.groupName,
  });

  final String idGroup;
  final List<StoreUser> listUser;
  final String groupName;

  @override
  State<ChatTextWidget> createState() => _ChatTypeWidgetState();
}

class _ChatTypeWidgetState extends State<ChatTextWidget> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  bool isFirstScroll = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SharedPreferencesManager.saveTimeSeenChat(widget.idGroup);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leadingWidth: 30.w,
        leading: CustomInkWell(
            child: Assets.icons.iconBack.svg(width: 28.r),
            onTap: () async {
              await SharedPreferencesManager.saveTimeSeenChat(widget.idGroup);
              if (mounted) {
                context.popRoute().then((value) =>
                    getIt<GroupCubit>().updateLastSeen(widget.idGroup));
              }
            }),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: widget.listUser.isNotEmpty
          ? CustomInkWell(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder(
                          stream: ChatService.instance.streamMessageGroup(
                              widget.idGroup, widget.listUser),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return const MessageEmptyScreen();
                              } else {
                                final chats = snapshot.data!.docs;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  if (_controller.hasClients) {
                                    isFirstScroll
                                        ? _controller.jumpTo(_controller
                                                .position.maxScrollExtent +
                                            90.h)
                                        : _controller.animateTo(
                                            _controller
                                                    .position.maxScrollExtent +
                                                0.h,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.linear);
                                  }
                                  isFirstScroll = false;
                                });
                                return ListView.builder(
                                    itemCount: chats.length,
                                    controller: _controller,
                                    padding: EdgeInsets.only(
                                        bottom: isFirstScroll ? 20.h : 0),
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
                  buildInput(),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Container buildInput() {
    final ValueNotifier isShowButtonSend = ValueNotifier(false);
    return Container(
      height: 88.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffEAEAEA)))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              context
                  .read<ChatTypeCubit>()
                  .update(const ChatTypeState(type: TypeChat.location));
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff42474C).withOpacity(0.3),
                      blurRadius: 17,
                    )
                  ]),
              child: Assets.icons.icLocation.svg(width: 20.r, height: 20.r),
            ),
          ),
          12.w.horizontalSpace,
          Expanded(
              child: TextField(
            controller: textController,
            onChanged: (value) {
              if (value.isEmpty) {
                isShowButtonSend.value = false;
              } else {
                isShowButtonSend.value = true;
              }
            },
            decoration: InputDecoration(
              suffixIcon: ValueListenableBuilder(
                  valueListenable: isShowButtonSend,
                  builder: (context, value, child) {
                    return value
                        ? IconButton(
                            onPressed: () async {
                              if (textController.text.isNotEmpty) {
                                await getIt<GroupCubit>().sendMessage(
                                    content: textController.text,
                                    idGroup: widget.idGroup);
                                getIt<FirebaseMessageService>()
                                    .sendChatNotification(
                                  widget.idGroup,
                                  widget.groupName,
                                );
                                textController.clear();
                              }
                            },
                            icon: Assets.icons.icSend.svg(width: 20.r))
                        : const SizedBox();
                  }),
              hintText: 'Message',
              hintStyle:
                  TextStyle(color: const Color(0xff6C6C6C), fontSize: 14.sp),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
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
        ],
      ),
    );
  }
}
