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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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

var fakeData = [
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8587323, "lng": 151.2100055},
      "viewport": {
        "northeast": {"lat": -33.85739847010727, "lng": 151.2112436298927},
        "southwest": {"lat": -33.86009812989271, "lng": 151.2085439701072},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/bar-71.png",
    "icon_background_color": "#FF9E67",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/bar_pinlet",
    "name": "Cruise Bar",
    "opening_hours": {"open_now": false},
    "photos": [
      {
        "height": 608,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/112582655193348962755">A Google User</a>',
        ],
        "photo_reference":
            "Aap_uECvJIZuXT-uLDYm4DPbrV7gXVPeplbTWUgcOJ6rnfc4bUYCEAwPU_AmXGIaj0PDhWPbmrjQC8hhuXRJQjnA1-iREGEn7I0ZneHg5OP1mDT7lYVpa1hUPoz7cn8iCGBN9MynjOPSUe-UooRrFw2XEXOLgRJ-uKr6tGQUp77CWVocpcoG",
        "width": 1080,
      },
    ],
    "place_id": "ChIJi6C1MxquEmsR9-c-3O48ykI",
    "plus_code": {
      "compound_code": "46R6+G2 The Rocks, New South Wales",
      "global_code": "4RRH46R6+G2",
    },
    "price_level": 2,
    "rating": 4,
    "reference": "ChIJi6C1MxquEmsR9-c-3O48ykI",
    "scope": "GOOGLE",
    "types": [
      "bar",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment"
    ],
    "user_ratings_total": 1269,
    "vicinity":
        "Level 1, 2 and 3, Overseas Passenger Terminal, Circular Quay W, The Rocks",
  },
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8675219, "lng": 151.2016502},
      "viewport": {
        "northeast": {"lat": -33.86614532010728, "lng": 151.2031259298927},
        "southwest": {"lat": -33.86884497989272, "lng": 151.2004262701072},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color": "#7B9EB0",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name": "Sydney Harbour Dinner Cruises",
    "opening_hours": {"open_now": true},
    "photos": [
      {
        "height": 835,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/109764923610545394994">A Google User</a>',
        ],
        "photo_reference":
            "Aap_uEBVsYnNcrpRixtrlHBztigZh70CwYkNWZzQnqJ39SjeBo_wvgKf-kXc6tgaMLBdQrRKmxmSKjOezoZrv-sHKVbTX0OI48HBqYYVnQiZQ-WGeuQDsLEPwX7LaVPa68nUAxX114Zpqt7bryoO9wL4qXdgEnopbOp5WWLALhKEHoIEH7f7",
        "width": 1200,
      },
    ],
    "place_id": "ChIJM1mOVTS6EmsRKaDzrTsgids",
    "plus_code": {
      "compound_code": "46J2+XM Sydney, New South Wales",
      "global_code": "4RRH46J2+XM",
    },
    "rating": 4.8,
    "reference": "ChIJM1mOVTS6EmsRKaDzrTsgids",
    "scope": "GOOGLE",
    "types": [
      "tourist_attraction",
      "travel_agency",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment",
    ],
    "user_ratings_total": 9,
    "vicinity": "32 The Promenade, Sydney",
  },
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8676569, "lng": 151.2017213},
      "viewport": {
        "northeast": {"lat": -33.86629922010728, "lng": 151.2031712798927},
        "southwest": {"lat": -33.86899887989272, "lng": 151.2004716201073},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color": "#7B9EB0",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name": "Clearview Sydney Harbour Cruises",
    "opening_hours": {"open_now": false},
    "photos": [
      {
        "height": 685,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/114394575270272775071">Clearview Glass Boat Cruises</a>',
        ],
        "photo_reference":
            "Aap_uEAlExjnXA0VWyb_oYwCJ8utWG_Ennhwmn_xadpgenMNUgTuxrvgf1Xdw4bsbL6kFSWH7bhbpVHK1esdNY37ancJvbL_Gnsc7EZ5KEBNPvYZ_ZEyLco4a5v34LFkodxfFZbJ-ejO3zN4W_0C37P5jAmTnLWMNFYUPvoU3UMi70qHRNF5",
        "width": 1024,
      },
    ],
    "place_id": "ChIJNQfwZTiuEmsR1m1x9w0E2V0",
    "plus_code": {
      "compound_code": "46J2+WM Sydney, New South Wales",
      "global_code": "4RRH46J2+WM",
    },
    "rating": 3.8,
    "reference": "ChIJNQfwZTiuEmsR1m1x9w0E2V0",
    "scope": "GOOGLE",
    "types": [
      "travel_agency",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment",
    ],
    "user_ratings_total": 49,
    "vicinity": "32 The Promenade King Street Wharf 5, Sydney",
  },
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8677035, "lng": 151.2017297},
      "viewport": {
        "northeast": {"lat": -33.86634597010728, "lng": 151.2031781298927},
        "southwest": {"lat": -33.86904562989272, "lng": 151.2004784701072},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color": "#7B9EB0",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name": "Sydney Harbour Lunch Cruise",
    "opening_hours": {"open_now": false},
    "photos": [
      {
        "height": 545,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/102428257696490257922">Sydney Harbour Lunch Cruise</a>',
        ],
        "photo_reference":
            "Aap_uEBFyQ2xDzHk7dGF_FTvNeJ01NQD6GROq89rufdGQl5Gi0zVfpnETBjPK2v7UEDl_6F-m8aR5FcEWJMqPaH4Oh_CQh2jaUAUAesUInucpCe7OFdleSYJ_8kgunhsIvGf1D1s_pes6Rk2JMVEs8rEs6ZHSTmUQXX2Yh-Gt9MuPQdYNuNv",
        "width": 969,
      },
    ],
    "place_id": "ChIJUbf3iDiuEmsROJxXbhYO7cM",
    "plus_code": {
      "compound_code": "46J2+WM Sydney, New South Wales",
      "global_code": "4RRH46J2+WM",
    },
    "rating": 3.9,
    "reference": "ChIJUbf3iDiuEmsROJxXbhYO7cM",
    "scope": "GOOGLE",
    "types": [
      "travel_agency",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment",
    ],
    "user_ratings_total": 23,
    "vicinity": "5/32 The Promenade, Sydney",
  },
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8675883, "lng": 151.2016452},
      "viewport": {
        "northeast": {"lat": -33.86623847010728, "lng": 151.2029950298927},
        "southwest": {"lat": -33.86893812989273, "lng": 151.2002953701073},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color": "#7B9EB0",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name": "Sydney Showboats - Dinner Cruise With Show",
    "opening_hours": {"open_now": false},
    "photos": [
      {
        "height": 4912,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/105311284660389698992">A Google User</a>',
        ],
        "photo_reference":
            "Aap_uED1aGaMs8xYfiuzeBqVcFsk3yguUujdE4S3rNThMpLtoU0RukF40KCt0CAxgHP1HoY8Z7NYcWvax6qmMMVPBbmzGhoaiwiAAyv2GGA9vhcgsJ5w0LweT0y1lgRGZxU3nZIdNLiYAp9JHM171UkN04H6UqYSxKVZ8N_f2aslkqOaBF_e",
        "width": 7360,
      },
    ],
    "place_id": "ChIJjRuIiTiuEmsRCHhYnrWiSok",
    "plus_code": {
      "compound_code": "46J2+XM Sydney, New South Wales",
      "global_code": "4RRH46J2+XM",
    },
    "rating": 4.1,
    "reference": "ChIJjRuIiTiuEmsRCHhYnrWiSok",
    "scope": "GOOGLE",
    "types": [
      "travel_agency",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment",
    ],
    "user_ratings_total": 119,
    "vicinity": "32 The Promenade, King Street Wharf, 5, Sydney",
  },
  {
    "business_status": "OPERATIONAL",
    "geometry": {
      "location": {"lat": -33.8677035, "lng": 151.2017297},
      "viewport": {
        "northeast": {"lat": -33.86634597010728, "lng": 151.2031781298927},
        "southwest": {"lat": -33.86904562989272, "lng": 151.2004784701072},
      },
    },
    "icon":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
    "icon_background_color": "#7B9EB0",
    "icon_mask_base_uri":
        "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
    "name": "Magistic Cruises",
    "opening_hours": {"open_now": true},
    "photos": [
      {
        "height": 1536,
        "html_attributions": [
          '<a href="https://maps.google.com/maps/contrib/103073818292552522030">A Google User</a>',
        ],
        "photo_reference":
            "Aap_uEC8bq-YphfIDcdxANBfgGMBIX2B0ggNep9ddVoePj6sfdcdusIn07x8biaxevZ_6BpzDDRsUL8No5P3ftI4on_pqbAbIEUL5gFGgezpVZ3M9GWvKdJm3njO_aJaghWl4_aQb75c0WGYDRFPhn6fWsLkD7KxodviJeCX4OCGt1eRJnlK",
        "width": 2048,
      },
    ],
    "place_id": "ChIJxRjqYTiuEmsRGebAA_chDLE",
    "plus_code": {
      "compound_code": "46J2+WM Sydney, New South Wales",
      "global_code": "4RRH46J2+WM",
    },
    "rating": 3.9,
    "reference": "ChIJxRjqYTiuEmsRGebAA_chDLE",
    "scope": "GOOGLE",
    "types": [
      "tourist_attraction",
      "travel_agency",
      "restaurant",
      "food",
      "point_of_interest",
      "establishment",
    ],
    "user_ratings_total": 99,
    "vicinity": "King Street Wharf, 32 The Promenade, Sydney",
  },
];
