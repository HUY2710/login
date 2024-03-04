import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
    this.isScrollable = true,
  });

  final TabController controller;
  final List<Widget> tabs;
  final void Function(int index)? onTap;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Color(0xffEAEAEA))),
      // padding: EdgeInsets.all(2.r),
      child: _TabBar(
        controller: controller,
        tabs: tabs,
        onTap: onTap,
        isScrollable: isScrollable,
      ),
    );
  }
}

class _TabBar extends TabBar {
  const _TabBar({
    required super.tabs,
    required super.controller,
    super.isScrollable = true,
    super.onTap,
  });

  @override
  TabBarIndicatorSize? get indicatorSize => TabBarIndicatorSize.tab;

  @override
  Decoration? get indicator => BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xffB67DFF),
            Color(0xff7B3EFF),
          ],
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color(0x1F000000),
        //     blurRadius: 3,
        //     spreadRadius: 1,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      );

  @override
  EdgeInsetsGeometry? get labelPadding =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);

  @override
  Color? get labelColor => Colors.white;

  @override
  TextStyle? get labelStyle =>
      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500);

  @override
  Color? get unselectedLabelColor => const Color(0xffCCADFF);

  @override
  Color? get dividerColor => Colors.transparent;
}
