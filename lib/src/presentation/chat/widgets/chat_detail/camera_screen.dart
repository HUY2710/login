import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/navigation/app_router.dart';
import '../../../../gen/gens.dart';
import '../../../../shared/helpers/gradient_background.dart';
import '../../../../shared/helpers/logger_utils.dart';
import '../../../../shared/widgets/custom_inkwell.dart';

@RoutePage()
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraController(
      cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => const CameraDescription(
            name: '',
            lensDirection: CameraLensDirection.external,
            sensorOrientation: 0),
      ),
    ).then((value) => controller?.setFlashMode(FlashMode.off));
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(false);
    controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      logger.e(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    controller?.takePicture().then((XFile? file) async {
      if (mounted && file != null) {
        context.pushRoute(ImageResultRoute(image: File(file.path)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const SizedBox(),
        ),
        bottomNavigationBar: SizedBox(height: 88.h),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: CameraPreview(
                  controller!,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButtonItem(
                        icon: Assets.icons.icFlash,
                        onTap: () async {
                          if (controller?.value.flashMode == FlashMode.off) {
                            await controller?.setFlashMode(FlashMode.torch);
                          } else {
                            await controller?.setFlashMode(FlashMode.off);
                          }
                        },
                      ),
                      buildButtonCenter(),
                      buildButtonItem(
                        icon: Assets.icons.icRoate,
                        onTap: () async {
                          if (controller?.value.description.lensDirection ==
                              CameraLensDirection.front) {
                            _initializeCameraController(
                              cameras.firstWhere(
                                (camera) =>
                                    camera.lensDirection ==
                                    CameraLensDirection.back,
                                orElse: () => const CameraDescription(
                                    name: '',
                                    lensDirection: CameraLensDirection.external,
                                    sensorOrientation: 0),
                              ),
                            ).then((value) =>
                                controller?.setFlashMode(FlashMode.off));
                          } else {
                            _initializeCameraController(
                              cameras.firstWhere(
                                (camera) =>
                                    camera.lensDirection ==
                                    CameraLensDirection.front,
                                orElse: () => const CameraDescription(
                                    name: '',
                                    lensDirection: CameraLensDirection.external,
                                    sensorOrientation: 0),
                              ),
                            ).then((value) =>
                                controller?.setFlashMode(FlashMode.off));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              buildButtonClose()
            ],
          ),
        ));
  }

  Align buildButtonClose() {
    return Align(
      alignment: const Alignment(0.9, -0.95),
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
          onTap: () => context.popRoute()),
    );
  }

  CustomInkWell buildButtonCenter() {
    return CustomInkWell(
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(.2),
          ),
          child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradientBackground,
              ),
              child: Assets.icons.icCamera.svg()),
        ),
        onTap: () {
          onTakePictureButtonPressed();
        });
  }

  CustomInkWell buildButtonItem({
    required SvgGenImage icon,
    required VoidCallback onTap,
  }) {
    return CustomInkWell(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(.2),
          ),
          child: icon.svg(),
        ),
        onTap: () => onTap());
  }
}

List<CameraDescription> cameras = <CameraDescription>[];
