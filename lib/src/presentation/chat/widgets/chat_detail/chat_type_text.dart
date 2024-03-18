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

  Container buildInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.h),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffEAEAEA)))),
      child: Row(
        children: [
          buildButtonSendLocation(),
          16.w.horizontalSpace,
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
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: _inputStyle(),
          )),
          Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              buildButtonCamera(),
              if (!getIt<MyPurchaseManager>().state.isPremium())
                Positioned(
                  right: 0,
                  child: ShadowContainer(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset(
                      Assets.icons.premium.icPremiumSvg.path,
                      width: 10.r,
                    ),
                  ),
                )
            ],
          ),
          buildButtonGallery(),
        ],
      ),
    );
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      suffixIcon: ValueListenableBuilder(
          valueListenable: isShowButtonSend,
          builder: (context, value, child) {
            return value
                ? IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20.r,
                    onPressed: () async {
                      if (textController.text.isNotEmpty) {
                        await getIt<GroupCubit>().sendMessage(
                          content: textController.text.trimLeft().trimRight(),
                          idGroup: widget.idGroup,
                          groupName: widget.groupName,
                        );
                        textController.clear();
                        isShowButtonSend.value = false;
                      }
                    },
                    icon: Assets.icons.icSend.svg(width: 20.r))
                : const SizedBox();
          }),
      hintText: context.l10n.messages,
      hintStyle: TextStyle(color: const Color(0xff6C6C6C), fontSize: 14.sp),
      contentPadding: EdgeInsets.only(left: 18.w, bottom: 12.w, top: 12.h),
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
    );
  }

  IconButton buildButtonGallery() {
    return IconButton(
        onPressed: () async {
          final bool isPremium = getIt<MyPurchaseManager>().state.isPremium();

          ///TODO: remove !
          if (!isPremium) {
            EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
            final XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              showLoading();
              final url = await FirebaseStorageClient.instance.uploadImage(
                  idGroup: widget.idGroup, imageFile: File(image.path));
              ChatService.instance.sendImage(
                  content: '',
                  idGroup: widget.idGroup,
                  groupName: widget.groupName,
                  imageUrl: url);
              hideLoading();
            }
          } else {
            context.pushRoute(PremiumRoute());
          }
        },
        icon: Assets.icons.icGallery.svg(width: 20.r));
  }

  IconButton buildButtonCamera() {
    return IconButton(
        onPressed: () async {
          final bool isPremium = getIt<MyPurchaseManager>().state.isPremium();

          ///TODO: remove !
          if (isPremium) {
            final result = await context.pushRoute(const CameraRoute()) ?? '';
            if (result != '') {
              showLoading();
              final url = await FirebaseStorageClient.instance.uploadImage(
                  idGroup: widget.idGroup, imageFile: File(result.toString()));
              ChatService.instance.sendImage(
                  content: '',
                  idGroup: widget.idGroup,
                  groupName: widget.groupName,
                  imageUrl: url);
              hideLoading();
            }
          } else {
            context.pushRoute(PremiumRoute());
          }
        },
        icon: Assets.icons.icCameraFill.svg(width: 20.r));
  }

  GestureDetector buildButtonSendLocation() {
    return GestureDetector(
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

  String formatDateTime(DateTime dateTime) {
    final String formattedDateTime = DateFormat('EEE ${context.l10n.at} HH:mm',
            '${Locale(getIt<LanguageCubit>().state.languageCode)}')
        .format(dateTime);
    return formattedDateTime.toUpperCase();
  }
}
