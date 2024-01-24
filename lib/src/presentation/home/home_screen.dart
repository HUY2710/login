import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../map/map_screen.dart';
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const MapScreen(),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 16.w,
            child: const GroupBar(),
          ),
        ],
      ),
    );
  }
}
