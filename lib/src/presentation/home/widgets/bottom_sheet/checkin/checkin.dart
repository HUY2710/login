import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../module/iap/my_purchase_manager.dart';
import '../../../../../config/navigation/app_router.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/extension/context_extension.dart';
import '../../../../../shared/widgets/containers/shadow_container.dart';
import '../../../../../shared/widgets/custom_inkwell.dart';
import '../show_bottom_sheet_home.dart';
import 'checkin_location.dart';

class CheckInWidget extends StatelessWidget {
  const CheckInWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPurchaseManager, PurchaseState>(
        builder: (context, purchaseState) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              showAppModalBottomSheet(
                context: context,
                builder: (context) => const CheckInLocation(),
              );
            },
            child: ShadowContainer(
              borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
              maxWidth: MediaQuery.sizeOf(context).width - 80.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Assets.icons.icCheckin.path),
                  12.horizontalSpace,
                  Text(
                    context.l10n.checkIn,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: const Color(0xff8E52FF),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          8.horizontalSpace,
          if (!purchaseState.isPremium())
            Center(
              child: CustomInkWell(
                onTap: () => context.pushRoute(const PremiumRoute()),
                child: ShadowContainer(
                  width: 80.r,
                  height: 40.r,
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
                  child: Row(
                    children: [
                      Assets.icons.premium.icPremiumSvg.svg(),
                      8.horizontalSpace,
                      Text(
                        'PRO',
                        style: TextStyle(
                            color: const Color(0xff8E52FF),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}
