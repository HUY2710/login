import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presentation/create/cubit/code_type_cubit.dart';
import '../constants/app_constants.dart';
import '../extension/context_extension.dart';
import '../helpers/gradient_background.dart';
import 'custom_inkwell.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.cubit});

  final CodeTypeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: 170.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.containerBorder.r),
        border: Border.all(
          color: const Color(0xffEAEAEA),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                height: constraints.maxHeight,
                duration: const Duration(milliseconds: 300),
                left:
                    cubit.state == CodeType.code ? 0 : constraints.maxWidth / 2,
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                    gradient: gradientBackground,
                    borderRadius:
                        BorderRadius.circular(AppConstants.containerBorder.r),
                  ),
                ),
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildCodeButton(context, constraints.maxWidth / 2,
                        constraints.maxHeight),
                    buildQrCodeButton(context, constraints.maxWidth / 2,
                        constraints.maxHeight)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildQrCodeButton(BuildContext context, double width, double height) {
    return CustomInkWell(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: Text(
            context.l10n.qrCode,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: cubit.state == CodeType.code
                    ? const Color(0XFFCCADFF)
                    : Colors.white),
          ),
        ),
        onTap: () => cubit.update(CodeType.qrCode));
  }

  Widget buildCodeButton(BuildContext context, double width, double height) {
    return CustomInkWell(
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: Text(
            context.l10n.code,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: cubit.state == CodeType.code
                    ? Colors.white
                    : const Color(0XFFCCADFF)),
          ),
        ),
        onTap: () => cubit.update(CodeType.code));
  }
}
