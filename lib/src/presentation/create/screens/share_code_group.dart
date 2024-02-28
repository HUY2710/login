import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class ShareCodeGroupScreen extends StatelessWidget with PermissionMixin {
  const ShareCodeGroupScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: context.l10n.shareCodeNow,
              onTap: () async {
                try {
                  EasyAds.instance.appLifecycleReactor
                      ?.setIsExcludeScreen(true);
                  final box = context.findRenderObject() as RenderBox?;
                  await Share.shareWithResult(
                    code,
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                  );
                } finally {}
              },
            ),
            TextButton(
              onPressed: () async {
                final bool statusLocation = await checkPermissionLocation();
                if (!statusLocation && context.mounted) {
                  getIt<AppRouter>()
                      .replaceAll([PermissionRoute(fromMapScreen: false)]);
                  return;
                } else if (context.mounted) {
                  getIt<AppRouter>().replaceAll([HomeRoute()]);
                }
              },
              child: Text(context.l10n.shareItLater),
            ),
            20.verticalSpace,
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.shareCode.path,
              width: 200.w,
            ),
            DottedBorder(
              color: const Color(0xff8E52FF),
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Text(
                      '${code.substring(0, 3)}-${code.substring(3, 6)}'
                          .toUpperCase(),
                      style: TextStyle(
                        color: const Color(0xff8E52FF),
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                context.l10n.inviteCodeContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
