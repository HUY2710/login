import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../gen/gens.dart';
import '../../../../global/global.dart';
import '../../../../services/location_service.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/helpers/gradient_background.dart';
import '../../../../shared/mixin/widget_mixi.dart';
import '../../../../shared/widgets/custom_inkwell.dart';

@RoutePage()
class ImageResultScreen extends StatefulWidget {
  const ImageResultScreen({super.key, required this.image});

  final File image;

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen>
    with WidgetMixin {
  String address = '';
  final repaintKey = GlobalKey();
  String imgPathResult = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      address = await LocationService().getCurrentAddress(LatLng(
          Global.instance.currentLocation.latitude,
          Global.instance.currentLocation.longitude));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            buildButtonClose(),
            30.h.verticalSpace,
            buildImagePreview(),
            16.h.verticalSpace,
            Row(
              children: [
                buildButtonBorder(
                  context,
                  icon: Assets.icons.icShareLocation,
                  title: context.l10n.share,
                  onTap: () async {
                    final resultBytes =
                        await widgetToBytes(repaintKey: repaintKey);
                    await Share.shareXFiles(
                      [XFile(saveToCacheDirectory(resultBytes!))],
                    );
                  },
                ),
                16.w.horizontalSpace,
                buildButtonBorder(
                  context,
                  icon: Assets.icons.icSave,
                  title: context.l10n.savePicture,
                  onTap: () {
                    _saveImage();
                  },
                ),
              ],
            ),
            16.h.verticalSpace,
            buildButtonSend(context)
          ],
        ),
      ),
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

  CustomInkWell buildButtonSend(BuildContext context) {
    return CustomInkWell(
        child: Container(
          width: double.infinity,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: gradientBackground,
              borderRadius:
                  BorderRadius.circular(AppConstants.containerBorder)),
          child: Text(
            context.l10n.send,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () async {
          final resultBytes = await widgetToBytes(repaintKey: repaintKey);
          imgPathResult = saveToCacheDirectory(resultBytes!);
          if (mounted) {
            await context
                .popRoute()
                .then((value) => context.popRoute(imgPathResult));
          }
        });
  }

  Expanded buildButtonBorder(
    BuildContext context, {
    required SvgGenImage icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: FilledButton.icon(
        onPressed: () => onTap(),
        icon: icon.svg(
            colorFilter:
                const ColorFilter.mode(Color(0xff8E52FF), BlendMode.srcIn)),
        label: Text(
          title,
          style: TextStyle(
              color: const Color(0xff8E52FF),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  side: const BorderSide(color: Color(0xffEAEAEA)))),
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: RepaintBoundary(
        key: repaintKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: 1.sw * 0.8,
              child: Image.file(
                widget.image,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: 1.sw * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.3),
              ),
              child: Row(
                children: [
                  Assets.icons.icLocationImage.svg(),
                  8.h.horizontalSpace,
                  Expanded(
                    child: Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Align buildButtonClose() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomInkWell(
          child: Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.2), shape: BoxShape.circle),
            child: Icon(
              Icons.close,
              size: 18.r,
              color: Colors.white,
            ),
          ),
          onTap: () => context.popRoute(imgPathResult)),
    );
  }
}
