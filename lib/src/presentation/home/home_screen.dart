import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/activity_recognition_service.dart';
import '../map/map_screen.dart';
import 'widgets/group/group_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityRecognitionService.instance.initStreamActivityRecognition();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const MapScreen(),
          Positioned(
            top: ScreenUtil().statusBarHeight == 0
                ? 20.h
                : ScreenUtil().statusBarHeight,
            left: 16.w,
            child: const GroupBar(),
          ),
        ],
      ),
    );
  }
}
