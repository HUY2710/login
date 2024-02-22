import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../module/iap/my_purchase_manager.dart';
import '../../../module/iap/product_id.dart';
import '../../config/di/di.dart';
import '../../gen/gens.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/widgets/custom_inkwell.dart';
import 'cubit/indicator_cubit.dart';

@RoutePage()
class PremiumScreen extends StatelessWidget {
  PremiumScreen({super.key});
  final CarouselController controller = CarouselController();

  Future<void> _launchUrl(String url) async {
    // EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch ');
    }
  }

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
                    child: BlocBuilder<MyPurchaseManager, PurchaseState>(
                  builder: (context, purchaseState) {
                    if (purchaseState.storeState == StoreState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (purchaseState.storeState ==
                        StoreState.notAvailable) {
                      return const Center(
                        child: Text('Not avaiable'),
                      );
                    }

                    final weeklyProduct =
                        purchaseState.getProductGroup(productKeyWeekly);
                    final monthlyProduct =
                        purchaseState.getProductGroup(productKeyMonthly);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CarouselSlider(
                          carouselController: controller,
                          items: [
                            buildItem(
                              context,
                              svgItem: Assets.icons.premium.icNoAds,
                              title: 'No ads',
                              subTitle:
                                  'Enjoy a completely ad-free app experience',
                              index: 0,
                            ),
                            buildItem(
                              context,
                              svgItem: Assets.icons.premium.icNearPlace,
                              title: 'Check in at nearby places',
                              subTitle:
                                  'Explore interesting places around you by checking in',
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
                            // autoPlay: false,
                            aspectRatio: 207 / 136,
                            onPageChanged: (index, reason) {
                              context.read<IndicatorCubit>().update(index);
                            },
                          ),
                        ),
                        20.h.verticalSpace,
                        buildIndicator(),
                        40.h.verticalSpace,
                        Text(
                          'Try 3 days for free',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xff7D7D7D),
                          ),
                        ),
                        Text(
                          'Then \$5.99}/week, cancel anytime.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff343434),
                          ),
                        ),
                        16.h.verticalSpace,
                        buildButtonSubmit(item: weeklyProduct),
                        8.h.verticalSpace,
                        buildDivider(),
                        8.h.verticalSpace,
                        buildButtonMonth(item: monthlyProduct),
                        12.h.verticalSpace,
                        buildRestoreButton(),
                        30.h.verticalSpace,
                        buildRowTextButton(),
                        10.h.verticalSpace,
                      ],
                    );
                  },
                ))
              ],
            );
          },
        ),
      ),
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              // width: double.infinity,
              color: const Color(0xffE9E6ED),
            ),
          ),
          9.w.horizontalSpace,
          Text(
            'or',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xff7D7D7D)),
          ),
          9.w.horizontalSpace,
          Expanded(
            child: Container(
              height: 1,
              // width: double.infinity,
              color: const Color(0xffE9E6ED),
            ),
          ),
        ],
      ),
    );
  }

  Row buildRowTextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              _launchUrl(UrlConstants.urlTerms);
            },
            child: Text(
              'Term of Use',
              style: TextStyle(
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
                color: Color(0xff7D7D7D),
              ),
            )),
        TextButton(
            onPressed: () {
              _launchUrl(UrlConstants.urlPOLICY);
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
                color: Color(0xff7D7D7D),
              ),
            ))
      ],
    );
  }

  FilledButton buildRestoreButton() {
    return FilledButton.icon(
      onPressed: () {},
      icon: Assets.icons.premium.icRestore.svg(),
      label: Text(
        'Restore Purchase',
        style: TextStyle(fontSize: 13.sp, color: const Color(0Xff8E52FF)),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
    );
  }

  CustomInkWell buildButtonMonth({required List<PurchasableProduct> item}) {
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 17.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // gradient: gradientBackground,
              border: Border.all(width: 2, color: const Color(0xffB67DFF)),
              borderRadius: BorderRadius.circular(15.r)),
          child: Text(
            '\$12.99/Monthly',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff8E52FF)),
          ),
        ),
        onTap: () {
          getIt<MyPurchaseManager>().buy(item.first);
        });
  }

  Widget buildButtonSubmit({required List<PurchasableProduct> item}) {
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 17.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: gradientBackground,
              borderRadius: BorderRadius.circular(15.r)),
          child: Text(
            'Start free trial now',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        onTap: () {
          getIt<MyPurchaseManager>().buy(item.first);
        });
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
