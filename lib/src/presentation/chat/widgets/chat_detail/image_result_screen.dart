import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../global/global.dart';
import '../../../../services/location_service.dart';

@RoutePage()
class ImageResultScreen extends StatefulWidget {
  const ImageResultScreen({
    super.key,
    required this.image,
  });

  final File image;

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  String address = '';
  final repaintKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      address = await LocationService().getCurrentAddress(LatLng(
          Global.instance.currentLocation.latitude,
          Global.instance.currentLocation.longitude));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.popRoute();
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Center(
        child: RepaintBoundary(
          key: repaintKey,
          child: Stack(
            children: [
              Image.file(
                widget.image,
              ),
              Positioned(
                bottom: 20.h,
                left: 16.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMEd().add_jms().format(DateTime.now())),
                    Text(address)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
