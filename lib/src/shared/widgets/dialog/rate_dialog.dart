import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../../app/cubit/rate_status_cubit.dart';
import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../config/remote_config.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../constants/app_constants.dart';
import '../../extension/context_extension.dart';
import '../../helpers/logger_utils.dart';
import 'rate_success_dialog.dart';
import 'rating_bar.dart';

Future<void> showRatingDialog({bool fromSetting = false}) async {
  final appContext = getIt<AppRouter>().navigatorKey.currentContext!;
  final rated = appContext.read<RateStatusCubit>().state;
  if (rated && !fromSetting) {
    return;
  }

  EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
  final InAppReview inAppReview = InAppReview.instance;
  if (!RemoteConfigManager.instance.willShowAd && Platform.isIOS) {
    if (await inAppReview.isAvailable()) {
      return inAppReview.requestReview();
    } else if (fromSetting) {
      return inAppReview.openStoreListing(
        appStoreId: AppConstants.appIOSId,
      );
    }
  } else {
    return showDialog(
      barrierDismissible: false,
      context: appContext,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext ctx) => RatingDialog(fromSetting: fromSetting),
    );
  }
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, this.fromSetting = false});

  final bool fromSetting;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final ValueNotifier<double> rateValue = ValueNotifier<double>(5);

  @override
  void dispose() {
    rateValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ValueListenableBuilder<double>(
              valueListenable: rateValue,
              builder: (_, double value, __) {
                return Image.asset(
                  'assets/icons/rates/emotion${value.toInt()}.png',
                  height: 72.r,
                  width: 72.r,
                  fit: BoxFit.fill,
                );
              },
            ),
            16.verticalSpace,
            ValueListenableBuilder<double>(
                valueListenable: rateValue,
                builder: (_, double value, __) {
                  String rateTitle = 'context.l10n.goodRate';
                  if (value < 4) {
                    rateTitle = 'context.l10n.badRate';
                  }

                  return Text(
                    rateTitle,
                    style: TextStyle(
                      fontSize: 20.sp,
                      height: 28 / 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
            SizedBox(height: 16.h),
            RatingBar.builder(
              minRating: 1,
              initialRating: 5,
              glowColor: Colors.white,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (BuildContext context, int index) {
                return Assets.icons.rates.fullStar.svg(
                  height: 30.h,
                  width: 30.w,
                );
              },
              unratedBuilder: (BuildContext context, int index) {
                return Assets.icons.rates.emptyStar.svg(
                  height: 30.h,
                  width: 30.w,
                );
              },
              onRatingUpdate: (double value) => rateValue.value = value,
            ),
            SizedBox(height: 24.h),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(200.w, 40.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r))),
              onPressed: _rateApp,
              child: const Text('Rate'),
            ),
            11.verticalSpace,
            TextButton(
              onPressed: () {
                exitApp();
                context.popRoute();
              },
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void exitApp() {
    if (Global.instance.isExitApp) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  Future<void> showThanksDialog() async {
    await showDialog(
      context: getIt<AppRouter>().navigatorKey.currentContext!,
      builder: (context) {
        Timer(
          const Duration(seconds: 1),
          () {
            exitApp();
            context.popRoute();
          },
        );
        return RateSuccessDialog(context);
      },
    );
  }

  Future<void> _rateApp() async {
    if (mounted) {
      context.read<RateStatusCubit>().update(true);
    }
    if (rateValue.value == 5) {
      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      await context.popRoute();
      await _openReview();
      await showThanksDialog();
    } else {
      if (context.mounted) {
        exitApp();
        await context.popRoute();
      }
    }
  }

  Future<void> _openReview() async {
    try {
      if (await InAppReview.instance.isAvailable()) {
        await InAppReview.instance.requestReview();
      } else if (widget.fromSetting) {
        InAppReview.instance.openStoreListing(
          appStoreId: AppConstants.appIOSId,
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
