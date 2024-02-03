import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/navigation/app_router.dart';
import '../../gen/assets.gen.dart';
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
      appBar: AppBar(title: const Text('Setting')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 32.h),
            Container(
              color: Colors.green,
              child: Assets.images.markers.markerBg
                  .image(width: 150.r, gaplessPlayback: true),
            ),
            ItemSetting(
              text: 'context.l10n.language',
              icon: 'Assets.icons.settings.icLanguage.path',
              onTap: () => context.pushRoute(LanguageRoute()),
            ),
            Builder(builder: (context) {
              return ItemSetting(
                text: 'context.l10n.share',
                icon: 'Assets.icons.settings.icShare.path',
                onTap: () => shareApp(context),
              );
            }),
            ItemSetting(
              text: 'context.l10n.about',
              icon: 'Assets.icons.settings.icAbout.path',
              onTap: () => context.pushRoute(const AboutRoute()),
            ),
            ItemSetting(
              text: 'context.l10n.rate',
              icon: 'Assets.icons.settings.icRate.path',
              onTap: () => showRatingDialog(fromSetting: true),
            ),
            ItemSetting(
              text: 'context.l10n.privacyPolicy',
              icon: 'Assets.icons.settings.icPrivacy.path',
              onTap: _launchUrl,
            ),
          ],
        ),
      ),
    );
  }
}
