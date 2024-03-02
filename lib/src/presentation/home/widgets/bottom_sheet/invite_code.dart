import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/helpers/gradient_background.dart';
import '../../../../shared/widgets/custom_inkwell.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/my_drag.dart';
import '../../../create/cubit/code_type_cubit.dart';

class InviteCode extends StatelessWidget {
  InviteCode({super.key, required this.code});
  final String code;
  final CodeTypeCubit codeTypeCubit = getIt<CodeTypeCubit>();
  Future<void> shareCode(BuildContext context, String code) async {
    try {
      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareWithResult(
        code,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MyDrag(),
        // TabBarWidget(codeTypeCubit: ,)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 80),
            Text(
              context.l10n.inviteCode,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: MyColors.black34,
              ),
            ),
            TextButton(
              onPressed: () {
                context.popRoute();
              },
              child: GradientText(
                context.l10n.done,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        50.h.verticalSpace,
        SizedBox(
          width: 249.w,
          child: Text(
            context.l10n.inviteCodeContent,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyColors.black34,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
        16.h.verticalSpace,
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xffEAEAEA))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              GradientText(
                '${code.substring(0, 3)} - ${code.substring(3)}'.toUpperCase(),
                style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600),
              ),
              CustomInkWell(
                child: Assets.icons.icCopy.svg(width: 24.r),
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: code.toUpperCase()));
                },
              )
            ],
          ),
        ),
        32.verticalSpace,
        GestureDetector(
          onTap: () => shareCode(context, code),
          child: Container(
            width: 260.w,
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                gradient: gradientBackground),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.icShareLocation
                    .svg(width: 24.r, color: Colors.white),
                8.horizontalSpace,
                Text(
                  context.l10n.shareCode,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        50.verticalSpace,
      ],
    );
  }
}

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key, required this.codeTypeCubit});

  final CodeTypeCubit codeTypeCubit;

  @override
  State<TabBarWidget> createState() => _BuildTabBarState();
}

class _BuildTabBarState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      controller: tabController,
      onTap: (index) {
        if (index == 0) {
          widget.codeTypeCubit.update(CodeType.code);
        } else {
          widget.codeTypeCubit.update(CodeType.qrCode);
        }
      },
      tabs: [
        Text(
          'Code',
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
        Text(
          'Qr code',
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
