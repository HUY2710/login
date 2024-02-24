import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_history_place/store_history_place.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/widgets/containers/shadow_container.dart';
import '../../../shared/widgets/custom_circle_avatar.dart';
import '../../../shared/widgets/my_drag.dart';
import '../../direction/direction_map.dart';
import '../../home/widgets/bottom_sheet/show_bottom_sheet_home.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../../map/widgets/battery_bar.dart';
import 'item_history_place.dart';

class HistoryPlace extends StatefulWidget {
  const HistoryPlace({super.key, required this.user});
  final StoreUser user;

  @override
  State<HistoryPlace> createState() => _HistoryPlaceState();
}

class _HistoryPlaceState extends State<HistoryPlace> {
  List<StoreHistoryPlace>? historyPlaces;
  @override
  void initState() {
    super.initState();
    fetchHistoryPlaces();
  }

  Future<void> fetchHistoryPlaces() async {
    if (getIt<SelectGroupCubit>().state != null) {
      try {
        final result = await FirestoreClient.instance.getListHistoryPlace(
            idGroup: getIt<SelectGroupCubit>().state!.idGroup!,
            idUser: widget.user.code);
        if (result != null) {
          setState(() {
            historyPlaces = result;
          });
        }
      } catch (error) {
        debugPrint('error get history place:$error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xff19E04B);
    final int battery = widget.user.batteryLevel;

    if (battery <= 20) {
      color = Colors.red;
    }
    if (battery > 20 && battery <= 30) {
      color = const Color(0xffFFDF57);
    }

    if (battery > 30) {
      color = const Color(0xff0FEC47);
    }
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 26.h),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                color: Colors.white.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffABABAB).withOpacity(0.3),
                  )
                ]),
            child: Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Column(
                children: [
                  const Center(
                    child: MyDrag(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 95.w),
                        child: Text(
                          widget.user.userName,
                          style: TextStyle(
                            color: MyColors.black34,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.popRoute().then(
                                (value) => showAppModalBottomSheet(
                                  context: context,
                                  builder: (context) => DirectionMap(
                                    user: widget.user,
                                  ),
                                ),
                              );
                        },
                        child: ShadowContainer(
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          child: Text(
                            'Get routes',
                            style: TextStyle(
                              color: const Color(0xff8E52FF),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 6.w),
                        child: BatteryBar(
                          batteryLevel: widget.user.batteryLevel,
                          color: color,
                          online: true,
                          radiusActive: 8.r,
                          heightBattery: 12.h,
                          widthBattery: 24,
                          borderWidth: 1,
                          borderRadius: 4.r,
                          stylePercent: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      SvgPicture.asset(Assets.icons.icShareLocation.path),
                      2.horizontalSpace,
                      Expanded(
                        child: Text(
                          widget.user.location?.address ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 123.h,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                24.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Today',
                          style: TextStyle(
                              color: MyColors.black34,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SvgPicture.asset(Assets.icons.icSteps.path),
                      8.horizontalSpace,
                      Text(
                        '${widget.user.steps} steps',
                        style: TextStyle(
                            color: const Color(0xff6C6C6C),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: historyPlaces == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : historyPlaces!.isEmpty
                          ? const Center(child: Text('No history'))
                          : ListView.builder(
                              itemCount: historyPlaces!.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              itemBuilder: (context, index) {
                                final StoreHistoryPlace historyPlace =
                                    historyPlaces![index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: ItemHistoryPlace(
                                    historyPlace: historyPlace,
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BorderCircleAvatar(
                path: widget.user.avatarUrl,
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
