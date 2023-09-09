import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';

Future<void> showRatingDialog() {
  return showDialog(
    context: getIt<AppRouter>().navigatorKey.currentContext!,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext ctx) => const RatingDialog(),
  );
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

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
                return SvgPicture.asset(
                  'assets/icons/svg/rates/rate_${value.toInt()}.svg',
                  height: 72.h,
                  width: 72.w,
                );
              },
            ),
            SizedBox(height: 16.h),
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
            //  RatingBar.builder(
            //     minRating: 1,
            //     initialRating: 5,
            //     glowColor: Colors.white,
            //     itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            //     itemBuilder: (BuildContext context, int index) {
            //       return Assets.icons.svg.rates.starRate.svg(
            //         height: 30.h,
            //         width: 30.w,
            //       );
            //     },
            //     unratedBuilder: (BuildContext context, int index) {
            //       return Assets.icons.svg.rates.starRate.svg(
            //           height: 30.h, width: 30.w, color: const Color(0xffD9D9D9));
            //     },
            //     onRatingUpdate: (double value) => rateValue.value = value,
            //   ),
            SizedBox(height: 24.h),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.7,
            //   child: mainBtn(
            //     height: 40,
            //     radius: 12,
            //     fontSize: 20,
            //     context: context,
            //     title: context.l10n.rate,
            //     onTap: () async {
            //       if (rateValue.value == 0) {
            //         return;
            //       }
            //       if (rateValue.value == 5) {
            //         EasyAds.instance.appLifecycleReactor
            //             ?.setIsExcludeScreen(true);
            //         await InAppReview.instance.openStoreListing();
            //       }
            //       await getIt<AppStatusStorage>().saveExistRated();
            //       if (mounted) {
            //         Navigator.pop(context);
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             margin: const EdgeInsets.all(16),
            //             behavior: SnackBarBehavior.floating,
            //             duration: const Duration(seconds: 3),
            //             backgroundColor: context.colorScheme.primary,
            //             content: Center(
            //               child: Text(
            //                 context.l10n.thanks,
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 20.sp,
            //                   height: 20 / 14,
            //                   fontWeight: FontWeight.w700,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //       await Future.delayed(const Duration(seconds: 3));
            //     },
            //   ),
            // ),

            SizedBox(
              height: 16.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'context.l10n.notNow',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
