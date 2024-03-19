import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../global/global.dart';
import '../../../shared/helpers/time_helper.dart';
import '../../../shared/widgets/containers/shadow_container.dart';
import '../models/member_maker_data.dart';
import 'battery_bar.dart';

class BuildMarker extends StatefulWidget {
  const BuildMarker({
    super.key,
    this.index,
    this.streamController,
    required this.member,
    this.callBack,
    this.keyCap,
  });

  final int? index;
  final StoreUser member;
  final StreamController<MemberMarkerData>? streamController;
  final VoidCallback? callBack;
  final GlobalKey? keyCap;
  @override
  State<BuildMarker> createState() => _BuildMarkerState();
}

class _BuildMarkerState extends State<BuildMarker> {
  final GlobalKey _repaintKey = GlobalKey();

  void _generateMarker() {
    if (widget.callBack != null) {
      widget.callBack?.call();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (widget.streamController != null && widget.index != null) {
          widget.streamController?.add(
            MemberMarkerData(index: widget.index!, repaintKey: _repaintKey),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateMarker();
  }

  @override
  void didUpdateWidget(BuildMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateMarker();
  }

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xff19E04B);
    final int battery = widget.member.batteryLevel;

    if (battery <= 20) {
      color = Colors.red;
    }
    if (battery > 20 && battery <= 30) {
      color = const Color(0xffFFDF57);
    }

    if (battery > 30) {
      color = const Color(0xff0FEC47);
    }

    //nếu sos được bật và time limit của user đó < 10 thì mới show sos
    final bool sosStatus = widget.member.sosStore?.sos ?? false;
    final timeLimit = TimerHelper.checkTimeDifferenceCurrent(
      widget.member.sosStore?.sosTimeLimit ?? DateTime.now(),
      argMinute: 10,
    );
    return RepaintBoundary(
      key: widget.keyCap ?? _repaintKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //chỉ có ở những member khác
          if (widget.member.code != Global.instance.user?.code)
            ShadowContainer(
              blurRadius: 2,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: BatteryBar(
                batteryLevel: widget.member.batteryLevel,
                color: color,
                online: widget.member.online,
              ),
            ),
          8.verticalSpace,
          _buildMarker(
              color,
              battery,
              sosStatus &&
                  !timeLimit &&
                  widget.member.code != Global.instance.user?.code),
          8.verticalSpace,
          if (widget.member.code != Global.instance.user?.code)
            ShadowContainer(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              blurRadius: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 16.r,
                    width: 16.r,
                    decoration: BoxDecoration(
                      color: widget.member.online
                          ? const Color(0xff19E04B)
                          : const Color(0xffFFDF57),
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.horizontalSpace,
                  Flexible(
                    child: Text(
                      widget.member.userName,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: MyColors.black34),
                    ),
                  )
                ],
              ),
            )
          else
            Image.asset(
              Assets.images.markers.circleDot.path,
              width: 40.r,
            )
        ],
      ),
    );
  }

  Stack _buildMarker(Color color, int battery, bool sos) {
    _generateMarker();
    return Stack(
      children: [
        if (sos)
          Assets.images.markers.sosBgMarker
              .image(width: 150.r, gaplessPlayback: true)
        else
          Assets.images.markers.markerBg
              .image(width: 150.r, gaplessPlayback: true),

        _buildAvatar(),
        //demo
        Positioned(
          left: 0,
          bottom: 0,
          child: Image.asset(
            getType(),
            height: 60.r,
            width: 60.r,
            gaplessPlayback: true,
          ),
        ),

        if (sos)
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              Assets.images.sos.path,
              height: 50.r,
              width: 50.r,
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 150.r,
      height: 150.r,
      padding: const EdgeInsets.all(12).r,
      child: ClipOval(
        child: Image.asset(
          widget.member.avatarUrl,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  String getType() {
    if (widget.member.activityType == ActivityType.RUNNING.name) {
      return Assets.images.markers.running.path;
    }
    if (widget.member.activityType == ActivityType.ON_BICYCLE.name) {
      return Assets.images.markers.onBicycle.path;
    }
    if (widget.member.activityType == ActivityType.IN_VEHICLE.name) {
      return Assets.images.markers.car.path;
    }
    if (widget.member.activityType == ActivityType.WALKING.name) {
      return Assets.images.markers.walking.path;
    }
    if (widget.member.activityType == ActivityType.STILL.name) {
      return Assets.images.markers.still.path;
    }
    return Assets.images.markers.still.path;
  }
}
