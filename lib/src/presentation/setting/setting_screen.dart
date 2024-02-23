import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/navigation/app_router.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/dialog/rate_dialog.dart';
import '../../shared/widgets/main_switch.dart';
import '../home/widgets/dialog/action_dialog.dart';
import 'widgets/custom_item_setting.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSharing = false;

  Future<void> _launchUrl() async {
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    if (!await launchUrl(Uri.parse(UrlConstants.urlPOLICY),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ');
    }
  }

  Future<void> shareApp(BuildContext context) async {
    if (isSharing) {
      return;
    }
    isSharing = true;
    try {
      final String appLink = Platform.isAndroid
          ? AppConstants.appAndroidUrl
          : AppConstants.appIOSUrl;

      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareWithResult(
        appLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } finally {
      isSharing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildUsernameEditSetting(),
              24.verticalSpace,
              _buildHideMyLocationSetting(),
              16.verticalSpace,
              CustomItemSetting(
                onTap: () => context.pushRoute(const MapTypeRoute()),
                child: Row(
                  children: [
                    Assets.icons.icMap.svg(height: 24.h),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Map type',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Assets.icons.icNext.svg(height: 24.h),
                  ],
                ),
              ),
              16.verticalSpace,
              _buildLanguageSetting(),
              16.verticalSpace,
              _buildExternalSetting(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExternalSetting(BuildContext context) {
    return CustomItemSetting(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      multiChild: Column(
        children: [
          _buildRateUsSetting(),
          _buildDivider(),
          _buildPrivacyPolicySetting(),
          _buildDivider(),
          _buildShareSetting(context),
        ],
      ),
    );
  }

  Widget _buildShareSetting(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => shareApp(context),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: [
              Assets.icons.icShareLocationFill.svg(height: 24.h),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPrivacyPolicySetting() {
    return GestureDetector(
      onTap: _launchUrl,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Assets.icons.icPolicy.svg(height: 24.h),
            12.horizontalSpace,
            Expanded(
              child: Text(
                'Privacy policy',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateUsSetting() {
    return GestureDetector(
      onTap: () => showRatingDialog(fromSetting: true),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Assets.icons.icRate.svg(height: 24.h),
            12.horizontalSpace,
            Expanded(
              child: Text(
                'Rate us',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 0.5,
      color: Color(0xFFDEDEDE),
    );
  }

  Widget _buildLanguageSetting() {
    return CustomItemSetting(
      onTap: () => context.pushRoute(LanguageRoute()),
      child: Row(
        children: [
          Assets.icons.icLanguage.svg(height: 24.h),
          12.horizontalSpace,
          Expanded(
            child: Text(
              'Language',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          16.horizontalSpace,
          Assets.icons.icNext.svg(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHideMyLocationSetting() {
    final ValueCubit<bool> allowTrackingCubit =
        ValueCubit(Global.instance.user!.shareLocation);
    return Column(
      children: [
        CustomItemSetting(
          child: Row(
            children: [
              Assets.icons.icHideLocation.svg(height: 24.h),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  'Hide my location',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              16.horizontalSpace,
              BlocBuilder<ValueCubit<bool>, bool>(
                bloc: allowTrackingCubit,
                builder: (context, state) {
                  return MainSwitch(
                    value: state,
                    onChanged: (value) async {
                      if (!value) {
                        showDialog(
                          context: context,
                          builder: (context1) => ActionDialog(
                              title: 'Allow others to track',
                              subTitle:
                                  'Your live location will not update for others, do you want to turn off?',
                              confirmTap: () async {
                                try {
                                  await FirestoreClient.instance
                                      .updateUser({'shareLocation': value});
                                  allowTrackingCubit.update(value);
                                  Global.instance.user = Global.instance.user
                                      ?.copyWith(shareLocation: value);
                                  context1.popRoute();
                                } catch (error) {
                                  debugPrint('error:$error');
                                }
                              },
                              confirmText: 'Ok'),
                        );
                      } else {
                        try {
                          await FirestoreClient.instance
                              .updateUser({'shareLocation': value});
                          allowTrackingCubit.update(value);
                          Global.instance.user = Global.instance.user
                              ?.copyWith(shareLocation: value);
                        } catch (error) {
                          debugPrint('error:$error');
                        }
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameEditSetting() {
    return CustomItemSetting(
      onTap: () {
        // TODO: Implement for Edit username
      },
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(Global.instance.user!.avatarUrl),
                ),
                20.horizontalSpace,
                Expanded(
                  child: Text(
                    Global.instance.user?.userName ?? 'User',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
          16.horizontalSpace,
          GestureDetector(
            onTap: () => context.pushRoute(const EditInfoRoute()),
            child: Assets.icons.icEdit.svg(height: 28.h),
          ),
        ],
      ),
    );
  }
}
