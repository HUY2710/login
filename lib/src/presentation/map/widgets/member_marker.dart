import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
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
    final int battery = widget.member.batteryLevel ?? 100;

    if (battery <= 20) {
      color = Colors.red;
    }

    return RepaintBoundary(
      key: widget.keyCap ?? _repaintKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //chỉ có ở những member khác
          if (widget.member.code != Global.instance.user?.code)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: BatteryBar(
                  batteryLevel: widget.member.batteryLevel ?? 100,
                  color: color),
            ),
          8.verticalSpace,
          _buildMarker(color, battery),
          8.verticalSpace,
          Image.asset(
            Assets.images.markers.circleDot.path,
            width: 36.r,
            height: 36.r,
            gaplessPlayback: true,
          ),
        ],
      ),
    );
  }

  Stack _buildMarker(Color color, int battery) {
    // _generateMarker();
    return Stack(
      children: [
        Assets.images.markers.markerBg
            .image(width: 150.r, gaplessPlayback: true),

        _buildAvatar(),
        //demo
        Positioned(
          left: 0,
          bottom: 0,
          child: Image.asset(
            Assets.images.markers.car.path,
            height: 60.r,
            width: 60.r,
            gaplessPlayback: true,
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
          Assets.images.avatars.avatar1.path,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
