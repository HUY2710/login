import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/navigation/app_router.dart';
import '../../services/activity_recognition_service.dart';
import '../../services/firebase_message_service.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../onboarding/widgets/app_button.dart';
import 'widget/guide_first_permission.dart';
import 'widget/guide_first_permission_android.dart';
import 'widget/permission_content.dart';

@RoutePage()
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, required this.fromMapScreen});
  final bool fromMapScreen;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver, PermissionMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ValueCubit<bool?> locationCubit = ValueCubit(null);
    final ValueCubit<bool?> notifyCubit = ValueCubit(null);
    final ValueCubit<bool?> motionCubit = ValueCubit(null);
    final ValueCubit<int> typeRequest = ValueCubit(1);

    final ValueCubit<bool> showNotify = ValueCubit(false);
    final ValueCubit<bool> showMotion = ValueCubit(false);
    //1 request location
    //2 request notification
    //3 request motion

    Future<bool?> showGuidePermissionDialog(
        VoidCallback voidCallback, BuildContext context) async {
      final status = await showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return GuideFirstPermission(
              title: context.l10n.pleaseShareLocation,
              subTitle: context.l10n.permissionsGreateSub,
              backgroundColor: Colors.white.withOpacity(0.95),
              confirmTap: () => context.popRoute(true),
              confirmText: context.l10n.continueText,
            );
          }
          return GuideFirstPermissionAndroid(
            title: context.l10n.pleaseShareLocation,
            subTitle: context.l10n.subLocation,
            confirmTap: () => context.popRoute(true),
            confirmText: context.l10n.allow,
          );
        },
      );
      return status;
    }

    return Scaffold(
      body: PermissionContent(
        locationCubit: locationCubit,
        notifyCubit: notifyCubit,
        motionCubit: motionCubit,
        typeRequest: typeRequest,
        showMotion: showMotion,
        showNotify: showNotify,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ValueCubit<int>, int>(
              bloc: typeRequest,
              builder: (context, state) {
                return AppButton(
                  title: context.l10n.continueText,
                  onTap: () async {
                    if (state == 1) {
                      final result = await showGuidePermissionDialog(
                          requestPermissionLocation, context);
                      if (result == null) {
                        return;
                      }
                      final status = await requestPermissionLocation();
                      locationCubit.update(status);
                      showNotify.update(true);
                      typeRequest.update(2);
                    }

                    if (state == 2) {
                      final status = await requestNotification();
                      if (status) {
                        await FirebaseMessageService().startService();
                      }
                      notifyCubit.update(status);
                      showMotion.update(true);
                      typeRequest.update(3);
                    }
                    if (state == 3) {
                      final status = await requestActivityRecognition();
                      if (status) {
                        ActivityRecognitionService.instance
                            .initActivityRecognitionService();
                      }
                      motionCubit.update(status);
                      typeRequest.update(0); //không request nữa
                      if (!widget.fromMapScreen && context.mounted) {
                        context.router.replaceAll([const GuideRoute()]);
                      }
                    }
                  },
                );
              },
            ),
            TextButton(
              onPressed: () {
                if (context.mounted && !widget.fromMapScreen) {
                  context.replaceRoute(const GuideRoute());
                } else if (context.mounted) {
                  context.popRoute();
                }
              },
              child: Text(context.l10n.later),
            )
          ],
        ),
      ),
    );
  }
}
