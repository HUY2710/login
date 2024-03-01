import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../gen/assets.gen.dart';
import '../../extension/context_extension.dart';

class NoIternetDialog extends StatelessWidget {
  const NoIternetDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return InternetConnection().hasInternetAccess;
      },
      child: AlertDialog(
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.h.verticalSpace,
            Assets.images.noInternet.image(width: 104.w, height: 77.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                context.l10n.noInternetConnection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff343434),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                context.l10n.noInternetConnectionSub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff6C6C6C),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            24.verticalSpace,
            const Divider(
              color: Color(0xffEAEAEA),
            ),
            GestureDetector(
              onTap: () => openAppSettings(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.goToSettings,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffB67DFF),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            12.verticalSpace,
          ],
        ),
      ),
    );
  }
}
