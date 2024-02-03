import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../config/di/di.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../data/models/store_message/store_message.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/member_manager.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/gradient_text.dart';
import 'cubits/chat_cubit.dart';
import 'cubits/chat_type_cubit.dart';
import 'cubits/group_cubit.dart';
import 'services/chat_service.dart';
import 'utils/util.dart';

part './widgets/message_guess.dart';
part './widgets/message_user.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget implements AutoRouteWrapper {
  const ChatDetailScreen({super.key, required this.idGroup});
  final String idGroup;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => ChatCubit(),
      ),
      BlocProvider(
        create: (context) => ChatTypeCubit(),
      ),
    ], child: this);
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<StoreUser> listUser = [];
  BitmapDescriptor? marker;
  // late final ScrollController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final memberOfGroup =
          await MemberManager.getListMemberOfGroup(widget.idGroup);
      final listIdUser = memberOfGroup!.map((e) => e.idUser ?? '').toList();
      listUser = await ChatService.instance.getUserFromListId(listIdUser);
      final newMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          size: Size(52.r, 52.r),
          devicePixelRatio: ScreenUtil().pixelRatio,
        ),
        Assets.images.markers.markerChat.path,
      );
      marker = newMarker;

      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // _controller = ScrollController()
    //   ..jumpTo(_controller.position.maxScrollExtent);
    // _controller.jumpTo(_controller.position.maxScrollExtent);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatTypeCubit, TypeChat>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: state == TypeChat.text
              ? ChatTypeWidget(
                  idGroup: widget.idGroup,
                  listUser: listUser,
                )
              : Scaffold(
                  body: Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              Global.instance.location.latitude,
                              Global.instance.location.longitude,
                            ),
                            zoom: 16),
                        markers: {
                          Marker(
                            markerId: MarkerId(Global.instance.user!.code),
                            // icon: BitmapDescriptor.fromBytes(
                            //   e.marker!,
                            //   size: const Size.fromWidth(30),
                            // ))
                            position: LatLng(
                              Global.instance.location.latitude,
                              Global.instance.location.longitude,
                            ),
                            icon: marker ?? BitmapDescriptor.defaultMarker,
                          )
                        },
                        // polygons: <Polygon>{Polygon(polygonId: polygonId)},
                        // polylines: <Polyline>{Polyline(polylineId: polylineId)},
                        circles: <Circle>{
                          Circle(
                            circleId: const CircleId('circle_1'),
                            center: LatLng(
                              Global.instance.location.latitude,
                              Global.instance.location.longitude,
                            ),
                            radius: 100,
                            fillColor:
                                const Color(0xffA369FD).withOpacity(0.25),
                            strokeColor: const Color(0xffA369FD),
                            strokeWidth: 1,
                            zIndex: 1,
                          )
                        },
                      ),
                      Positioned(
                        top: ScreenUtil().statusBarHeight + 20,
                        left: 16.w,
                        child: GestureDetector(
                          onTap: () {
                            context.read<ChatTypeCubit>().update(TypeChat.text);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff42474C)
                                        .withOpacity(0.6),
                                    blurRadius: 17,
                                  )
                                ]),
                            child: GradientSvg(Assets.icons.icBack
                                .svg(width: 28.r, height: 28.r)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
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

class ChatTypeWidget extends StatefulWidget {
  const ChatTypeWidget(
      {super.key, required this.idGroup, required this.listUser});

  final String idGroup;
  final List<StoreUser> listUser;

  @override
  State<ChatTypeWidget> createState() => _ChatTypeWidgetState();
}

class _ChatTypeWidgetState extends State<ChatTypeWidget> {
  final TextEditingController textController = TextEditingController();
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
                                return ListView.builder(
                                    itemCount: chats.length,
                                    // controller: _controller,
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
              context.read<ChatTypeCubit>().update(TypeChat.location);
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
                                getIt<GroupCubit>().sendMessage(
                                    content: textController.text,
                                    idGroup: widget.idGroup);
                                textController.clear();
                              }
                            },
                            icon: Assets.icons.icSend.svg(width: 20.r))
                        : SizedBox();
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
          // 12.w.horizontalSpace,
          // GestureDetector(
          //   onTap: () async {
          //     if (textController.text.isNotEmpty) {
          //       getIt<GroupCubit>().sendMessage(
          //           content: textController.text, idGroup: widget.idGroup);
          //       textController.clear();
          //     }
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(10.r),
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(15.r),
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             color: const Color(0xff42474C).withOpacity(0.3),
          //             blurRadius: 17,
          //           )
          //         ]),
          //     child: GradientSvg(
          //         Assets.icons.icGallery.svg(width: 20.r, height: 20.r)),
          //   ),
          // )
        ],
      ),
    );
  }
}
