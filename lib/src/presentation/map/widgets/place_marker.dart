import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/store_place/store_place.dart';
import '../../../gen/assets.gen.dart';
import '../models/member_maker_data.dart';

class PlaceMarker extends StatefulWidget {
  const PlaceMarker({
    super.key,
    this.index,
    this.streamController,
    required this.place,
    this.callBack,
    this.keyCap,
  });

  final int? index;
  final StorePlace place;
  final StreamController<MemberMarkerData>? streamController;
  final VoidCallback? callBack;
  final GlobalKey? keyCap;
  @override
  State<PlaceMarker> createState() => _PlaceMarkerState();
}

class _PlaceMarkerState extends State<PlaceMarker> {
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
  void didUpdateWidget(PlaceMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateMarker();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.keyCap ?? _repaintKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //chỉ có ở những member khác
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Text(
              widget.place.namePlace,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          8.verticalSpace,
          _buildPlaceMarker(),
        ],
      ),
    );
  }

  Stack _buildPlaceMarker() {
    _generateMarker();
    return Stack(
      children: [
        _buildAvatar(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xffA369FD).withOpacity(0.5),
            const Color(0xffA369FD).withOpacity(0.25)
          ]),
          border: Border.all(
            color: const Color(0xffA369FD).withOpacity(0.5),
          ),
          shape: BoxShape.circle),
      padding: const EdgeInsets.all(12).r,
      child: ClipOval(
        child: SvgPicture.asset(
          widget.place.iconPlace,
          alignment: Alignment.topCenter,
          colorFilter: const ColorFilter.mode(
            Color(0xff7B3EFF),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
