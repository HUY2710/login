import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
                    debugPrint(
                        "========)))))) ${monthlyProduct.first.productDetails}");
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CarouseSliderPremium(),
                        16.h.verticalSpace,
                        buildIndicator(),
                        24.h.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              buildButtonWeek(item: weeklyProduct),
                              16.w.horizontalSpace,
                              buildButtonMonth(
                                  item: monthlyProduct,
                                  weeklyPrice: weeklyProduct
                                      .first.productDetails.rawPrice),
                            ],
                          ),
                        ),
                        12.h.verticalSpace,
                        buildTextcancel(),
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

  Widget buildTextTitle() {
    return Positioned.fromRect(
      rect: Rect.fromLTWH(
          16.w, ScreenUtil().statusBarHeight + 20.h, 1.sw * 0.78, 1.sh * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 100.verticalSpace,
          buildFirstCloseButton(context),
          18.h.verticalSpace,
          Text(
            context.l10n.premiumTitle,
            style: TextStyle(
              height: 1.0,
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
              color: const Color(0xff410097).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r)),
          child: Text(context.l10n.useByAdsVersion,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffE2CEFF))),
        ),
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
        Flexible(
          flex: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      _launchUrl(UrlConstants.urlTerms);
                    },
                    child: AutoSizeText(
                      context.l10n.term,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                        color: const Color(0xff7D7D7D),
                      ),
                    )),
              ),
              Text(
                '|',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff7D7D7D),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        _launchUrl(UrlConstants.urlPOLICY);
                      },
                      child: AutoSizeText(
                        context.l10n.privacy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          color: const Color(0xff7D7D7D),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
        Flexible(flex: 2, child: buildRestoreButton())
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

  Widget buildButtonMonth(
      {required List<PurchasableProduct> item, required double weeklyPrice}) {
    final monthlyProduct = item.first;
    final formatter = NumberFormat.simpleCurrency(
      name: monthlyProduct.productDetails.currencyCode,
    );
    final monthPricePerWeek =
        formatter.format(monthlyProduct.productDetails.rawPrice / 4);
    final saved = (weeklyPrice - (monthlyProduct.productDetails.rawPrice / 4)) *
        100 /
        weeklyPrice;
    return Expanded(
        child: Container(
      height: 150.h,
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomInkWell(
              onTap: () {
                getIt<MyPurchaseManager>().buy(item.first);
              },
              child: Container(
                height: 123.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: gradientBackground,
                    borderRadius: BorderRadius.circular(15.r)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.l10n.monthly,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xffF2F8FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                            child: AutoSizeText(
                          item.first.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ))
                      ],
                    ),
                    18.h.verticalSpace,
                    buildDivider(color: const Color(0xffffffff)),
                    18.h.verticalSpace,
                    Text(
                      '$monthPricePerWeek/ ${context.l10n.week}',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, -0.8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff00C208),
                    Color(0xff71DD81),
                  ],
                ),
              ),
              child: Text(
                '-${saved.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget buildButtonWeek({
    required List<PurchasableProduct> item,
  }) {
    return Expanded(
        child: Container(
      height: 150.h,
      alignment: Alignment.bottomCenter,
      child: CustomInkWell(
        onTap: () {
          getIt<MyPurchaseManager>().buy(item.first);
        },
        child: Container(
          height: 123.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xffF7F3FF),
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      context.l10n.weekly,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  AutoSizeText(
                    item.first.price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff8E52FF),
                    ),
                  )
                ],
              ),
              18.h.verticalSpace,
              buildDivider(color: const Color(0xff894EFA)),
              18.h.verticalSpace,
              Text(
                context.l10n.mostPopular,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffA677FF)),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Row buildDivider({required Color color}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(.2)],
                begin: Alignment.center,
                end: Alignment.centerLeft,
                stops: const [0.0, 0.5],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(.2)],
                begin: Alignment.center,
                stops: const [0.0, 0.5],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextcancel() {
    return Text(
      context.l10n.youCanCancelAnyTime,
      style: TextStyle(
          fontSize: 13.sp,
          fontStyle: FontStyle.italic,
          color: MyColors.black34),
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
