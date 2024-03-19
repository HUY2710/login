import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseAuthWidget extends StatelessWidget {
  const BaseAuthWidget({
    super.key,
    this.actions,
    this.hasBack = true,
    required this.child,
    this.padding,
    this.resizeToAvoidBottomInset,
    this.onTapBack,
    this.bottomNavigationBar,
  });
  final List<Widget>? actions;
  final Widget child;
  final bool hasBack;
  final EdgeInsetsGeometry? padding;
  final bool? resizeToAvoidBottomInset;
  final Function()? onTapBack;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: actions,
        leading: hasBack
            ? GestureDetector(
                onTap: onTapBack ??
                    () {
                      context.popRoute();
                    },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              )
            : const SizedBox(),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
        child: child,
      ),
    );
  }
}
