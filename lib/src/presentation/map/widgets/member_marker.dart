import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../models/member_maker_data.dart';
import 'battery_bar.dart';

class BuildMarker extends StatefulWidget {
  const BuildMarker({
    super.key,
    required this.index,
    this.streamController,
    required this.member,
    this.callBack,
    required this.keyCap,
  });

  final int index;
  final StoreUser member;
  final StreamController<MemberMarkerData>? streamController;
  final VoidCallback? callBack;
  final GlobalKey keyCap;
  @override
  State<BuildMarker> createState() => _BuildMarkerState();
}

class _BuildMarkerState extends State<BuildMarker> {
  final GlobalKey _repaintKey = GlobalKey();

  void _generateMarker() {
    widget.callBack?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Future.delayed(const Duration(milliseconds: 500));
      // widget.streamController.add(
      //   MemberMarkerData(index: widget.index, repaintKey: _repaintKey),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    final int battery = widget.member.batteryLevel ?? 100;

    if (battery <= 20 && battery > 10) {
      color = Colors.black;
    } else if (battery <= 10) {
      color = Colors.red;
    }

    return RepaintBoundary(
      key: widget.keyCap,
      child: Container(
        height: 250.r,
        color: Colors.red,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Positioned(
            //   child: ConstrainedBox(
            //     constraints: BoxConstraints(
            //       minWidth: 120.r,
            //     ),
            //     child: Container(
            //       margin: REdgeInsets.all(10),
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 10, vertical: 5).r,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(16).r,
            //         color: Colors.white,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black26,
            //             spreadRadius: 1,
            //             blurRadius: 5.r,
            //           ),
            //         ],
            //       ),
            //       child: Text(
            //         'NAME',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 20.sp),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned.fill(
              top: 60.r,
              child: Align(
                child: _buildMarker(color, battery),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Align(
                child: Image.asset(
                  Assets.images.markers.circleDot.path,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack _buildMarker(Color color, int battery) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50).r,
          child: Assets.images.markers.markerBg.image(
            width: 120.r,
            color: Colors.white,
          ),
        ),
        Positioned(
          height: 120.r,
          child: _buildAvatar(),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    _generateMarker();
    return Container(
      width: 120.r,
      height: 120.r,
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
