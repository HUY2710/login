import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../map/map_screen.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/float_right_app_bar.dart';
import 'widgets/group_bar.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapScreen(),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            right: 16.w,
            bottom: 0,
            child: const FloatRightAppBar(),
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 16.w,
            child: const GroupBar(),
          ),
          Positioned(
            bottom: 55.h,
            left: 0,
            right: 0,
            child: const BottomBar(),
          )
        ],
      ),
    );
  }
}
