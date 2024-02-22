part of '../../chat_detail_screen.dart';

class ChatLocationWidget extends StatefulWidget {
  const ChatLocationWidget({
    super.key,
    required this.marker,
    required this.textController,
    required this.idGroup,
  });

  final BitmapDescriptor? marker;
  final TextEditingController textController;
  final String idGroup;

  @override
  State<ChatLocationWidget> createState() => _ChatLocationWidgetState();
}

class _ChatLocationWidgetState extends State<ChatLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<ChatTypeCubit, ChatTypeState>(builder: (context, state) {
            return GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    state.lat != null
                        ? state.lat!
                        : Global.instance.currentLocation.latitude,
                    state.long != null
                        ? state.long!
                        : Global.instance.currentLocation.longitude,
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
                    Global.instance.currentLocation.latitude,
                    Global.instance.currentLocation.longitude,
                  ),
                  // icon: widget.marker ?? BitmapDescriptor.defaultMarker,
                )
              },

              // polygons: <Polygon>{Polygon(polygonId: polygonId)},
              // polylines: <Polyline>{Polyline(polylineId: polylineId)},
              circles: <Circle>{
                Circle(
                  circleId: const CircleId('circle_1'),
                  center: LatLng(
                    Global.instance.currentLocation.latitude,
                    Global.instance.currentLocation.longitude,
                  ),
                  radius: 100,
                  fillColor: const Color(0xffA369FD).withOpacity(0.25),
                  strokeColor: const Color(0xffA369FD),
                  strokeWidth: 1,
                  zIndex: 1,
                )
              },
            );
          }),
          Positioned(
            top: ScreenUtil().statusBarHeight + 20,
            left: 16.w,
            child: GestureDetector(
              onTap: () {
                context
                    .read<ChatTypeCubit>()
                    .update(const ChatTypeState(type: TypeChat.text));
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
                        color: const Color(0xff42474C).withOpacity(0.6),
                        blurRadius: 17,
                      )
                    ]),
                child: GradientSvg(
                    Assets.icons.icBack.svg(width: 28.r, height: 28.r)),
              ),
            ),
          ),
          // Positioned(
          //   // bottom: 0,
          //   child: Container(
          //     height: 400.h,
          //     padding: EdgeInsets.symmetric(horizontal: 16.w),
          //     // width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.vertical(
          //         top: Radius.circular(20.r),
          //         // right: Radius.circular(20.r),
          //       ),
          //     ),
          //     child: Column(
          //       children: [
          //         const MyDrag(),
          //         InputSearch(textController: widget.textController),
          //         24.h.verticalSpace,
          //         BlocBuilder<SendLocationCubit, SendLocationState>(
          //           builder: (context, locationState) {
          //             return Expanded(
          //                 child: ListView.separated(
          //                     // shrinkWrap: true,
          //                     padding:
          //                         const EdgeInsets.only(top: 0, bottom: 10),
          //                     itemBuilder: (context, index) {
          //                       if (index == 0) {
          //                         return CustomInkWell(
          //                           onTap: () {
          //                             context
          //                                 .read<SendLocationCubit>()
          //                                 .changeState(
          //                                     lat:
          //                                         Global.instance
          //                                             .currentLocation.latitude,
          //                                     long: Global.instance
          //                                         .currentLocation.longitude);
          //                           },
          //                           child: Row(
          //                             children: [
          //                               Assets.icons.icShareLocation.svg(
          //                                   width: 20.r,
          //                                   height: 20.r,
          //                                   colorFilter: const ColorFilter.mode(
          //                                       MyColors.primary,
          //                                       BlendMode.srcIn)),
          //                               12.w.horizontalSpace,
          //                               SizedBox(
          //                                 width: 1.sw * 0.7,
          //                                 child: Text(
          //                                   'My current location',
          //                                   overflow: TextOverflow.ellipsis,
          //                                   maxLines: 1,
          //                                   style: TextStyle(
          //                                     color: MyColors.black34,
          //                                     fontSize: 13.sp,
          //                                   ),
          //                                 ),
          //                               ),
          //                               const Spacer(),
          //                               if (locationState.lat ==
          //                                       Global.instance.currentLocation
          //                                           .latitude &&
          //                                   locationState.long ==
          //                                       Global.instance.currentLocation
          //                                           .longitude)
          //                                 const Icon(
          //                                   Icons.check,
          //                                   color: MyColors.primary,
          //                                 )
          //                             ],
          //                           ),
          //                         );
          //                       }
          //                       return CustomInkWell(
          //                         onTap: () {
          //                           context
          //                               .read<SendLocationCubit>()
          //                               .changeState(
          //                                   lat: places[index - 1]['geometry']
          //                                       ['location']['lat'],
          //                                   long: places[index - 1]['geometry']
          //                                       ['location']['lng']);
          //                         },
          //                         child: Row(
          //                           children: [
          //                             if (index == 0)
          //                               Assets.icons.icShareLocation.svg(
          //                                   width: 20.r,
          //                                   height: 20.r,
          //                                   colorFilter: const ColorFilter.mode(
          //                                       MyColors.primary,
          //                                       BlendMode.srcIn))
          //                             else
          //                               Assets.icons.icLocation.svg(),
          //                             12.w.horizontalSpace,
          //                             if (index == 0)
          //                               Text(
          //                                 'My current location',
          //                                 style: TextStyle(
          //                                   color: MyColors.primary,
          //                                   fontSize: 13.sp,
          //                                 ),
          //                               )
          //                             else
          //                               SizedBox(
          //                                 width: 1.sw * 0.7,
          //                                 child: Text(
          //                                   places[index - 1]['vicinity'],
          //                                   overflow: TextOverflow.ellipsis,
          //                                   maxLines: 1,
          //                                   style: TextStyle(
          //                                     color: MyColors.black34,
          //                                     fontSize: 13.sp,
          //                                   ),
          //                                 ),
          //                               ),
          //                             const Spacer(),
          //                             if (locationState.lat ==
          //                                     places[index - 1]['geometry']
          //                                         ['location']['lat'] &&
          //                                 locationState.long ==
          //                                     places[index - 1]['geometry']
          //                                         ['location']['lng'])
          //                               const Icon(
          //                                 Icons.check,
          //                                 color: MyColors.primary,
          //                               )
          //                           ],
          //                         ),
          //                       );
          //                     },
          //                     separatorBuilder: (context, index) {
          //                       return Padding(
          //                         padding: EdgeInsets.only(
          //                             left: 32.r, bottom: 8.h, top: 6.h),
          //                         child: const Divider(
          //                           thickness: 1,
          //                           color: Color(0xffEAEAEA),
          //                         ),
          //                       );
          //                     },
          //                     itemCount: places.length + 1));
          //           },
          //         ),
          //         10.h.verticalSpace,
          //         CustomInkWell(
          //           onTap: () {
          //             EasyLoading.show();
          //             ChatService.instance.sendMessageLocation(
          //                 content: '',
          //                 idGroup: widget.idGroup,
          //                 lat: Global.instance.currentLocation.latitude,
          //                 long: Global.instance.currentLocation.longitude);
          //             EasyLoading.dismiss();
          //           },
          //           child: Container(
          //             height: 40.h,
          //             width: double.infinity,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               gradient: gradientBackground,
          //               borderRadius: BorderRadius.circular(15.r),
          //             ),
          //             child: Text(
          //               'Send location',
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 16.sp,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ),
          //         ),
          //         (ScreenUtil().bottomBarHeight - 10).verticalSpace
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
      // bottomNavigationBar: ,
    );
  }
}
