import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/widgets/dialog/rate_dialog.dart';
import 'widgets/item_setting.dart';

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

  Future<void> shareApp() async {
    if (isSharing) {
      return;
    }
    isSharing = true;
    try {
      final String appLink = Platform.isAndroid
          ? AppConstants.appAndroidUrl
          : AppConstants.appIOSUrl;

      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      await Share.shareWithResult(appLink);
    } finally {
      isSharing = false;
    }
  }

  Future<void> rateApp() async {
    final isExistRate = await SharedPreferencesManager.isExistRated() ?? false;

    if (RemoteConfigManager.instance.shouldShowDefaultRating()) {
      EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      await InAppReview.instance.openStoreListing(
        appStoreId: AppConstants.appIOSId,
      );
      return;
    }

    if (!isExistRate) {
      showRatingDialog();
    } else {
      showDialog(
        context: getIt<AppRouter>().navigatorKey.currentContext!,
        builder: (context) {
          return Dialog(
              surfaceTintColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SvgPicture.asset(Assets.icons.svg.rates.rated.path),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const Text('Rate App'),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.45,
                    //   child: mainBtn(
                    //     radius: 12,
                    //     height: 40,
                    //     context: context,
                    //     title: 'Ok',
                    //     onTap: () async {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 32.h),
          ItemSetting(
            text: 'context.l10n.language',
            icon: 'Assets.icons.settings.icLanguage.path',
            onTap: () => context.pushRoute(LanguageRoute()),
          ),
          ItemSetting(
            text: 'context.l10n.share',
            icon: 'Assets.icons.settings.icShare.path',
            onTap: shareApp,
          ),
          ItemSetting(
            text: 'context.l10n.about',
            icon: 'Assets.icons.settings.icAbout.path',
            onTap: () => context.pushRoute(const AboutRoute()),
          ),
          ItemSetting(
            text: 'context.l10n.rate',
            icon: 'Assets.icons.settings.icRate.path',
            onTap: () => rateApp(),
          ),
          ItemSetting(
            text: 'context.l10n.privacyPolicy',
            icon: 'Assets.icons.settings.icPrivacy.path',
            onTap: _launchUrl,
          ),
        ],
      ),
    );
  }
}
