import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/navigation/app_router.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/firebase_message_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/dialog/rate_dialog.dart';
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
              _buildLanguageSetting(),
              16.verticalSpace,
              _buildExternalSetting(context),
              TextButton(
                onPressed: () {
                  FirebaseMessageService().sendPlaceNotification(
                    'FxfSRRHQgVkftlihDLMoBwkh',
                    true,
                    'Test 123',
                  );
                },
                child: const Text('Send notification'),
              )
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
              CupertinoSwitch(
                activeColor: const Color(0xFF7B3EFF),
                thumbColor: Colors.white,
                trackColor: Colors.black12,
                value: false,
                onChanged: (value) => {
                  // TODO: Implement to toggle hide location feature
                },
              ),
            ],
          ),
        ),
        4.verticalSpace,
        Text(
          'When you enable, your friends can’t see your Last Active Location.',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
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
          Assets.icons.icEdit.svg(height: 28.h),
        ],
      ),
    );
  }
}
