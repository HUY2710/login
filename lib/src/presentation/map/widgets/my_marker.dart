import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/models/activity_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/helpers/time_helper.dart';

class MyMarkerOnMap extends StatefulWidget {
  const MyMarkerOnMap({
    super.key,
    required this.member,
    this.callBack,
    required this.keyCap,
  });

  final StoreUser member;
  final VoidCallback? callBack;
  final GlobalKey keyCap;
  @override
  State<MyMarkerOnMap> createState() => _MyMarkerOnMapState();
}

class _MyMarkerOnMapState extends State<MyMarkerOnMap> {
  @override
  Widget build(BuildContext context) {
    //nếu sos được bật và time limit của user đó < 10 thì mới show sos
    final bool sosStatus = widget.member.sosStore?.sos ?? false;
    final timeLimit = TimerHelper.checkTimeDifferenceCurrent(
      widget.member.sosStore?.sosTimeLimit ?? DateTime.now(),
      argMinute: 10,
    );
    return RepaintBoundary(
      key: widget.keyCap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.verticalSpace,
          _buildMarker(sosStatus && !timeLimit),
          8.verticalSpace,
          Image.asset(
            Assets.images.markers.circleDot.path,
            width: 40.r,
          )
        ],
      ),
    );
  }

  Stack _buildMarker(bool sos) {
    return Stack(
      children: [
        if (sos)
          Assets.images.markers.sosMarkerBg
              .image(width: 150.r, gaplessPlayback: true)
        else
          Assets.images.markers.markerBg
              .image(width: 150.r, gaplessPlayback: true),
        _buildAvatar(),
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
