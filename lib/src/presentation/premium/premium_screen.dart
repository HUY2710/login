import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../module/iap/my_purchase_manager.dart';
import '../../../module/iap/product_id.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../gen/gens.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/gradient_background.dart';
import '../../shared/widgets/custom_inkwell.dart';
import 'cubit/indicator_cubit.dart';
import 'widgets/carouse_slider.dart';

@RoutePage()
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, this.fromStart = false});

  final bool fromStart;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isSelectedWeek = false;

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
      child: BlocListener<MyPurchaseManager, PurchaseState>(
          listenWhen: (previous, current) =>
              previous.isPremium() != current.isPremium(),
          listener: (context, state) {
            if (state.isPremium()) {
              context.popRoute();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                ElevatedButton(
                    onPressed: () {
                      context.pushRoute(HomeRoute());
                    },
                    child: const Text('Home'))
              ],
            ),
            body: Stack(
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
                buildTextTitle(),
                buildImageBackground(),
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
                    if (weeklyProduct.isEmpty || monthlyProduct.isEmpty) {
                      return const SizedBox();
                    }

                    final weekPrice =
                        weeklyProduct.first.productDetails.rawPrice;
                    final monthPrice =
                        monthlyProduct.first.productDetails.rawPrice;
                    final saved =
                        (weekPrice - (monthPrice / 4)) * 100 / weekPrice;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CarouseSliderPremium(),
                        16.h.verticalSpace,
                        buildIndicator(),
                        24.h.verticalSpace,
                        buildButtonWeek(item: weeklyProduct),
                        8.h.verticalSpace,
                        buildButtonMonth(item: monthlyProduct, save: saved),
                        12.h.verticalSpace,
                        buildButtonContinue(
                            weeklyProduct.first, monthlyProduct.first),
                        8.verticalSpace,
                        buildFirstCloseButton(context),
                        30.h.verticalSpace,
                        buildRowTextButton(),
                        10.h.verticalSpace,
                      ],
                    );
                  },
                ))
              ],
            ),
          )),
    );
  }

  Positioned buildTextTitle() {
    return Positioned.fromRect(
      rect: Rect.fromLTWH(16.w, -30.h, 1.sw * 0.65, 1.sh * 0.23),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          context.l10n.premiumTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Positioned buildImageBackground() {
    return Positioned.fromRect(
        rect: Rect.fromLTWH(0, 1.sh * 0.2, 1.sw, 1.sh),
        child: Container(
          padding: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  image: Assets.images.backgroundPremium.provider())),
          child: Align(
            alignment: const Alignment(1, -1.1),
            child: Assets.images.rocket.image(width: 152.w, height: 167.h),
          ),
        ));
  }

  CustomInkWell buildFirstCloseButton(BuildContext context) {
    return CustomInkWell(
        child: Text(context.l10n.useLimitedVersion,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54)),
        onTap: () {
          if (widget.fromStart) {
            AutoRouter.of(context).replace(HomeRoute());
          } else {
            context.popRoute();
          }
        });
  }

  Row buildRowTextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  _launchUrl(UrlConstants.urlTerms);
                },
                child: Text(
                  context.l10n.term,
                  style: TextStyle(
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    color: const Color(0xff7D7D7D),
                  ),
                )),
            Text(
              '|',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff7D7D7D),
              ),
            ),
            TextButton(
                onPressed: () {
                  _launchUrl(UrlConstants.urlPOLICY);
                },
                child: Text(
                  context.l10n.privacy,
                  style: TextStyle(
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    color: const Color(0xff7D7D7D),
                  ),
                ))
          ],
        ),
        buildRestoreButton()
      ],
    );
  }

  FilledButton buildRestoreButton() {
    return FilledButton.icon(
      onPressed: () => getIt<MyPurchaseManager>().restorePurchases(),
      icon: Assets.icons.premium.icRestore.svg(),
      label: Text(
        context.l10n.restore,
        style: TextStyle(fontSize: 13.sp, color: const Color(0Xff8E52FF)),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white)),
    );
  }

  CustomInkWell buildButtonMonth(
      {required List<PurchasableProduct> item, required double save}) {
    final isSelected = !isSelectedWeek;
    final monthlyProduct = item.first;
    final formatter = NumberFormat.simpleCurrency(
      name: monthlyProduct.productDetails.currencyCode,
    );
    final monthPricePerWeek =
        formatter.format(monthlyProduct.productDetails.rawPrice / 4);
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // gradient: gradientBackground,
              border: Border.all(
                  width: 2,
                  color: isSelected
                      ? const Color(0xffB67DFF)
                      : const Color(0xffB67DFF).withOpacity(0.3)),
              borderRadius:
                  BorderRadius.circular(AppConstants.widgetBorderRadius.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.monthly,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xff8E52FF)
                                : Colors.grey),
                      ),
                      8.horizontalSpace,
                      Text('$monthPricePerWeek/${context.l10n.week}',
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500))
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(
                        context.l10n.billedMonthlyTotal,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12.sp),
                      ),
                      4.horizontalSpace,
                      Text(item.first.price,
                          style: const TextStyle(fontWeight: FontWeight.w500))
                    ],
                  )
                ],
              ),
              if (isSelected)
                Radio(
                  activeColor: const Color(0xff8E52FF),
                  value: true,
                  groupValue: true,
                  onChanged: (val) {},
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
            ],
          ),
        ),
        onTap: () {
          if (!isSelectedWeek) {
            return;
          }
          setState(() {
            isSelectedWeek = false;
          });
        });
  }

  CustomInkWell buildButtonWeek({required List<PurchasableProduct> item}) {
    final isSelected = isSelectedWeek;
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: isSelected
                      ? const Color(0xffB67DFF)
                      : const Color(0xffB67DFF).withOpacity(0.3)),
              borderRadius:
                  BorderRadius.circular(AppConstants.widgetBorderRadius.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.weekly,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? const Color(0xff8E52FF) : Colors.grey),
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text(
                        context.l10n.billedWeeklyOnly,
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12.sp),
                      ),
                      4.horizontalSpace,
                      Text(item.first.price,
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500))
                    ],
                  )
                ],
              ),
              if (isSelected)
                Radio(
                  activeColor: const Color(0xff8E52FF),
                  value: true,
                  groupValue: true,
                  onChanged: (val) {},
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
            ],
          ),
        ),
        onTap: () {
          if (isSelectedWeek) {
            return;
          }
          setState(() {
            isSelectedWeek = true;
          });
        });
  }

  Widget buildButtonContinue(
      PurchasableProduct weekly, PurchasableProduct monthly) {
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: gradientBackground,
              borderRadius:
                  BorderRadius.circular(AppConstants.widgetBorderRadius.r)),
          child: Column(
            children: [
              Text(
                context.l10n.continueText,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Text(
                context.l10n.youCanCancelAnyTime,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              )
            ],
          ),
        ),
        onTap: () {
          final item = isSelectedWeek ? weekly : monthly;
          getIt<MyPurchaseManager>().buy(item);
        });
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
