import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/mixin/widget_mixi.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';
import '../cubit/code_type_cubit.dart';
import '../widgets/tab_bart.dart';

@RoutePage()
class ShareCodeGroupScreen extends StatefulWidget {
  const ShareCodeGroupScreen({super.key, required this.code});
  final String code;

  @override
  State<ShareCodeGroupScreen> createState() => _ShareCodeGroupScreenState();
}

class _ShareCodeGroupScreenState extends State<ShareCodeGroupScreen>
    with PermissionMixin, WidgetMixin {
  final GlobalKey repaintKey = GlobalKey();
  final codeTypeCubit = getIt<CodeTypeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => codeTypeCubit,
      child: Scaffold(
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
                    if (codeTypeCubit.state == CodeType.code) {
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.shareWithResult(
                        widget.code,
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                    } else {
                      final resultBytes =
                          await widgetToBytes(repaintKey: repaintKey);
                      await Share.shareXFiles(
                        [XFile(saveToCacheDirectory(resultBytes!))],
                      );
                    }
                  } finally {}
                },
              ),
              TextButton(
                onPressed: () async {
                  final bool statusPermission = await checkAllPermission();
                  if (!statusPermission && context.mounted) {
                    getIt<AppRouter>().replaceAll([const PermissionRoute()]);
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
          child: BlocBuilder<CodeTypeCubit, CodeType>(
            bloc: codeTypeCubit,
            builder: (context, state) {
              return Column(
                children: [
                  54.h.verticalSpace,
                  BuildTabBar(codeTypeCubit: codeTypeCubit),
                  82.h.verticalSpace,
                  if (state == CodeType.code)
                    _buildTabCodeView()
                  else
                    buildTabQrCodeView(),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Column buildTabQrCodeView() {
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
              data: widget.code,
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
                _saveImage();
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

  Widget _buildTabCodeView() {
    return Column(
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
                  '${widget.code.substring(0, 3)}-${widget.code.substring(3, 6)}'
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
      ],
    );
  }

  Future<void> _saveImage() async {
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
