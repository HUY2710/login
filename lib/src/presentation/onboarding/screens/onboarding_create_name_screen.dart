import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../widgets/app_button.dart';

@RoutePage()
class OnboardingCreateNameScreen extends StatelessWidget {
  const OnboardingCreateNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Let’s get started',
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    'What’s your name?',
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontWeight: FontWeight.w500,
                      fontSize: 24.sp,
                    ),
                  ),
                  24.verticalSpace,
                  Assets.images.markers.profileMaker.image(height: 100.h),
                  24.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        //
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Your name',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: const Color(0xFFCCADFF),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: const Color(0xFFCCADFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CustomAppBar(),
            Padding(
              padding: EdgeInsets.only(bottom: 36.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AppButton(
                  onTap: () {
                    context.pushRoute(const OnboardingCreateAvtPersonRoute());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 56.h),
      child: SizedBox(
        height: 30.h,
        child: Stack(
          children: [
            Assets.icons.icBack.svg(
              height: 28.h,
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Align(
              child: Text(
                'Text',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
