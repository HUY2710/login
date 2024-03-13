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

class _ChatTypeWidgetState extends State<ChatTextWidget>
    with AutoRouteAwareStateMixin {
  final TextEditingController textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final ValueNotifier isShowButtonSend = ValueNotifier(false);
  bool isFirstScroll = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didPop() async {
    await SharedPreferencesManager.saveTimeSeenChat(widget.idGroup);
    getIt<GroupCubit>().updateLastSeen(widget.idGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        // leadingWidth: 30.w,
        // toolbarHeight: 98.h,
        leading: CustomInkWell(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Assets.icons.iconBack.svg(),
            ),
            onTap: () => context.popRoute()),
        centerTitle: true,
        title: Text(
          widget.groupName,
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
                                return ListView.builder(
                                    itemCount: chats.length,
                                    controller: _controller,
                                    reverse: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          buildTextDay(index, chats),
                                          if (Utils.checkIsUser(
                                              code:
                                                  chats[index].data().senderId))
                                            MessageTypeUser(
                                              chats: chats,
                                              index: index,
                                            )
                                          else
                                            MessageTypeGuess(
                                              chats: chats,
                                              index: index,
                                            )
                                        ],
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
          : Center(
              child: SizedBox(
                height: 100.r,
                width: 100.r,
                child: const LoadingIndicator(
                  colors: [
                    Color.fromARGB(255, 113, 63, 207),
                    Color(0xffB78CFF),
                    Color(0xffD2B0FF)
                  ],
                  indicatorType: Indicator.ballScaleMultiple,
                ),
              ),
            ),
    );
  }

  Widget buildTextDay(
      int index, List<QueryDocumentSnapshot<MessageModel>> chats) {
    return (Utils.isMessageOnNewDay(index, chats) != null)
        ? Utils.isMessageOnNewDay(index, chats)!
            ? Utils.isToday(DateTime.parse(chats[index].data().sentAt))
                ? Text(
                    context.l10n.today,
                    style: TextStyle(
                        fontSize: 13.sp, color: const Color(0xff6C6C6C)),
                  )
                : Text(
                    formatDateTime(
                        DateTime.tryParse(chats[index].data().sentAt) ??
                            DateTime.now()),
                    style: TextStyle(
                        fontSize: 13.sp, color: const Color(0xff6C6C6C)))
            : const SizedBox()
        : const SizedBox();
  }

  Container buildInput() {
    return Container(
      height: 88.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffEAEAEA)))),
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                // EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
                // final result =
                //     await ImagePicker().pickImage(source: ImageSource.camera);
                // if (result != null && mounted) {
                //   context.pushRoute(ImageResultRoute(image: File(result.path)));
                // }
                context.pushRoute(const CameraRoute());
              },
              icon: Icon(Icons.camera_alt_rounded)),
          IconButton(
              onPressed: () async {
                EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
                final XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final url = await FirebaseStorageClient.instance.uploadImage(
                      idGroup: widget.idGroup, imageFile: File(image.path));
                  ChatService.instance.sendImage(
                      content: '',
                      idGroup: widget.idGroup,
                      groupName: widget.groupName,
                      imageUrl: url);
                }
              },
              icon: Icon(Icons.picture_in_picture)),
          GestureDetector(
            onTap: () async {
              ChatService.instance.sendMessageLocation(
                content: '',
                idGroup: widget.idGroup,
                lat: Global.instance.currentLocation.latitude,
                long: Global.instance.currentLocation.longitude,
                groupName: widget.groupName,
                context: context,
              );
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
              if (value.trimLeft().trimRight().isEmpty) {
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
                                  content: textController.text
                                      .trimLeft()
                                      .trimRight(),
                                  idGroup: widget.idGroup,
                                  groupName: widget.groupName,
                                );
                                textController.clear();
                              }
                            },
                            icon: Assets.icons.icSend.svg(width: 20.r))
                        : const SizedBox();
                  }),
              hintText: context.l10n.messages,
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

  String formatDateTime(DateTime dateTime) {
    final String formattedDateTime = DateFormat('EEE ${context.l10n.at} HH:mm',
            '${Locale(getIt<LanguageCubit>().state.languageCode)}')
        .format(dateTime);
    return formattedDateTime.toUpperCase();
  }
}
