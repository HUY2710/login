import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/gens.dart';
import '../../shared/helpers/gradient_background.dart';
import 'cubit/indicator_cubit.dart';

@RoutePage()
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IndicatorCubit(),
      child: Scaffold(
        body: BlocBuilder<IndicatorCubit, int>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Color(0xFFB67DFF), Color(0xFF7B3EFF)],
                    begin: Alignment.topRight,
                    end: Alignment.centerLeft,
                    stops: [0.2, 1.0],
                    // transform: GradientRotation(274 * (pi / 180)),
                  )),
                ),
                Positioned(
                  top: ScreenUtil().statusBarHeight + 16,
                  left: 16.w,
                  child: IconButton.filled(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => MyColors.primary.withOpacity(0.6))),
                      highlightColor: Colors.black,
                      iconSize: 20.r,
                      onPressed: () => context.popRoute(),
                      icon: Icon(
                        Icons.close,
                        size: 20.r,
                        color: Colors.white70,
                      )),
                ),
                Positioned.fromRect(
                  rect: Rect.fromLTWH(16.w, 0, 1.sw * 0.65, 1.sh * 0.23),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Unlimited access to all features',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned.fromRect(
                    rect: Rect.fromLTWH(0, 1.sh * 0.2, 1.sw, 1.sh),
                    child: Container(
                      padding: EdgeInsets.only(right: 15.w),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              image:
                                  Assets.images.backgroundPremium.provider())),
                      child: Align(
                        alignment: const Alignment(1, -1.1),
                        child: Assets.images.rocket
                            .image(width: 152.w, height: 167.h),
                      ),
                    )),
                Positioned.fill(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CarouselSlider(
                      items: [
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem()
                      ],
                      disableGesture: true,
                      options: CarouselOptions(
                        viewportFraction: 0.6,
                        height: 136,
                        // autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 5),
                        aspectRatio: 207 / 136,
                        onPageChanged: (index, reason) {
                          context.read<IndicatorCubit>().update(index);
                        },
                      ),
                    ),
                    20.h.verticalSpace,
                    buildIndicator(),
                    SizedBox(height: 100)
                  ],
                ))
              ],
            );
          },
        ),
      ),
    );
  }

  Container buildItem() {
    return Container(
      width: 207.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Color(0xffE9E6ED))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Assets.icons.premium.icNoAds.svg(),
              12.horizontalSpace,
              Text(
                'No ads',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          6.verticalSpace,
          Text(
            'Enjoy a completely ad-free app experience',
            style: TextStyle(fontSize: 12.sp),
          )
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return BlocBuilder<IndicatorCubit, int>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          height: 10.h,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: state == index ? gradientBackground : null,
                    color: MyColors.secondPrimary,
                  ),
                );
              },
              separatorBuilder: (context, index) => 8.horizontalSpace,
              itemCount: 4),
        );
      },
    );
  }
}
