import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import '../cubit/indicator_cubit.dart';

class CarouseSliderPremium extends StatefulWidget {
  const CarouseSliderPremium({super.key});

  @override
  State<CarouseSliderPremium> createState() => _CarouseSliderPremiumState();
}

class _CarouseSliderPremiumState extends State<CarouseSliderPremium> {
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndicatorCubit, int>(
      builder: (context, state) {
        return CarouselSlider(
          carouselController: controller,
          items: [
            buildItem(
              context,
              svgItem: Assets.icons.premium.icNoAds,
              title: 'No ads',
              subTitle: 'Enjoy a completely ad-free app experience',
              index: 0,
            ),
            buildItem(
              context,
              svgItem: Assets.icons.premium.icNearPlace,
              title: 'Check in at nearby places',
              subTitle: 'Explore interesting places around you by checking in',
              index: 1,
            ),
            buildItem(
              context,
              svgItem: Assets.icons.premium.icMember,
              title: 'Guide to group members',
              subTitle:
                  'Easily and quickly navigate to your location for members',
              index: 2,
            ),
            buildItem(
              context,
              svgItem: Assets.icons.premium.icSharePremium,
              title: 'Send my current location',
              subTitle:
                  'Easily and quickly navigate to your location for members',
              index: 3,
            )
          ],
          disableGesture: true,
          options: CarouselOptions(
            viewportFraction: 0.6,
            height: 136,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            aspectRatio: 207 / 136,
            onPageChanged: (index, reason) {
              context.read<IndicatorCubit>().update(index);
            },
          ),
        );
      },
    );
  }

  Widget buildItem(
    BuildContext context, {
    required int index,
    required SvgGenImage svgItem,
    required String title,
    required String subTitle,
  }) {
    return CustomInkWell(
      onTap: () {
        context.read<IndicatorCubit>().update(index);
        controller.animateToPage(index,
            curve: Curves.linear, duration: const Duration(milliseconds: 500));
      },
      child: Container(
        width: 207.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xffE9E6ED))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                svgItem.svg(),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            6.verticalSpace,
            Text(
              subTitle,
              style: TextStyle(fontSize: 12.sp),
            )
          ],
        ),
      ),
    );
  }
}
