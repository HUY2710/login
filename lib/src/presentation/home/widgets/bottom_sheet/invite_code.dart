import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/di/di.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/helpers/gradient_background.dart';
import '../../../../shared/mixin/widget_mixi.dart';
import '../../../../shared/widgets/custom_inkwell.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/my_drag.dart';
import '../../../create/cubit/code_type_cubit.dart';

class InviteCode extends StatelessWidget with WidgetMixin {
  InviteCode({super.key, required this.code});
  final String code;
  final CodeTypeCubit codeTypeCubit = getIt<CodeTypeCubit>();
  final GlobalKey repaintKey = GlobalKey();
  Future<void> shareCode(BuildContext context, String code) async {
    try {
      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      if (codeTypeCubit.state == CodeType.code) {
        final box = context.findRenderObject() as RenderBox?;
        await Share.shareWithResult(
          code,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      } else {
        final resultBytes = await widgetToBytes(repaintKey: repaintKey);
        await Share.shareXFiles([XFile(saveToCacheDirectory(resultBytes!))],
            text: context.l10n.qrCode);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CodeTypeCubit, CodeType>(
      bloc: codeTypeCubit,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyDrag(),
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
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            20.h.verticalSpace,
            TabBarWidget(codeTypeCubit: codeTypeCubit),
            38.h.verticalSpace,
            AnimatedCrossFade(
                firstChild: buildCodeTabView(context),
                secondChild: buildTabQrCodeView(context),
                crossFadeState: codeTypeCubit.state == CodeType.code
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300)),
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
      },
    );
  }

  Column buildTabQrCodeView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffEAEAEA),
              ),
              borderRadius: BorderRadius.circular(20.r)),
          child: RepaintBoundary(
            key: repaintKey,
            child: QrImageView(
              backgroundColor: Colors.white,
              data: code,
              size: 172.w,
            ),
          ),
        ),
        16.h.verticalSpace,
        SizedBox(
          width: 172.w,
          child: FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        side: const BorderSide(color: Color(0xffEAEAEA)))),
              ),
              onPressed: () async {
                _saveImage(context);
              },
              icon: Assets.icons.icSave.svg(
                  colorFilter: const ColorFilter.mode(
                      Color(0xff8E52FF), BlendMode.srcIn)),
              label: Text(
                context.l10n.savePicture,
                style: const TextStyle(
                  color: Color(0xff8E52FF),
                ),
              )),
        )
      ],
    );
  }

  Widget buildCodeTabView(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final result = await widgetToBytes(repaintKey: repaintKey);
    if (result != null) {
      try {
        await ImageGallerySaver.saveImage(result);
        if (context.mounted) {
          Fluttertoast.showToast(
              msg: '${context.l10n.save} ${context.l10n.success}');
        }
      } catch (error) {
        if (context.mounted) {
          Fluttertoast.showToast(msg: '${context.l10n.save} $error');
        }
      }
    }
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
      cubit: widget.codeTypeCubit,
    );
  }
}
