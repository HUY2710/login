import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/cubit/native_ad_status_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/widget/ads/banner_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/authentication_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/constants/url_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/main_switch.dart';
import '../home/cubit/banner_collapse_cubit.dart';
import '../home/widgets/dialog/action_dialog.dart';
import 'widgets/custom_item_setting.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutoRouteAwareStateMixin {
  bool isSharing = false;

  @override
  void didPopNext() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.didPopNext();
  }

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

  Widget? buildAd() {
    final bool isShow =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.banner_all);
    return BlocBuilder<NativeAdStatusCubit, bool>(
      builder: (context, state) {
        return Visibility(
          maintainState: true,
          visible: state && isShow,
          child: MyBannerAd(
            id: getIt<AppAdIdManager>().adUnitId.bannerAll,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.settings),
      bottomNavigationBar: buildAd(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildUsernameEditSetting(),
              24.verticalSpace,
              CustomItemSetting(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                multiChild: Column(
                  children: [
                    _buildHideMyLocationSetting(),
                    _buildDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: GestureDetector(
                        onTap: () => context.pushRoute(const MapTypeRoute()),
                        child: Row(
                          children: [
                            Assets.icons.icMap.svg(height: 24.h),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                context.l10n.mapType,
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
                    ),
                    _buildDivider(),
                    _buildLanguageSetting(),
                  ],
                ),
              ),
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
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().then(
                    (value) => context.router.replaceAll([SignInRoute()]));
              },
              child: const Text('Logout'))
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
                  context.l10n.share,
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
                context.l10n.privacy,
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
    final bool checkVisibleRate = RemoteConfigManager.instance.isShowRate();
    return checkVisibleRate
        ? GestureDetector(
            // onTap: () => showRatingDialog(fromSetting: true),
            onTap: () async {
              if (await InAppReview.instance.isAvailable()) {
                await InAppReview.instance.requestReview();
              } else {
                InAppReview.instance.openStoreListing(
                  appStoreId: AppConstants.appIOSId,
                );
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Assets.icons.icRate.svg(height: 24.h),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.l10n.rateUs,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildDivider() {
    return const Divider(
      height: 0.5,
      color: Color(0xFFDEDEDE),
    );
  }

  Widget _buildLanguageSetting() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: GestureDetector(
        onTap: () => context.pushRoute(LanguageRoute()),
        child: Row(
          children: [
            Assets.icons.icLanguage.svg(height: 24.h),
            12.horizontalSpace,
            Expanded(
              child: Text(
                context.l10n.language,
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
    );
  }

  Widget _buildHideMyLocationSetting() {
    final ValueCubit<bool> allowTrackingCubit =
        ValueCubit(Global.instance.user!.shareLocation);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Assets.icons.icHideLocation.svg(height: 24.h),
          12.horizontalSpace,
          Expanded(
            child: Text(
              context.l10n.allowOthersToTrack,
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
                    getIt<BannerCollapseAdCubit>().update(false);
                    showDialog(
                      context: context,
                      builder: (context1) => ActionDialog(
                          title: context.l10n.allowOthersToTrack,
                          subTitle: context.l10n.allowOthersToTrackSub,
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
                          confirmText: context.l10n.ok),
                    ).then(
                        (value) => getIt<BannerCollapseAdCubit>().update(true));
                  } else {
                    try {
                      await FirestoreClient.instance
                          .updateUser({'shareLocation': value});
                      allowTrackingCubit.update(value);
                      Global.instance.user =
                          Global.instance.user?.copyWith(shareLocation: value);
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
    );
  }

  Widget _buildUsernameEditSetting() {
    return CustomItemSetting(
      onTap: () {
        print(Global.instance.user);
      },
      child: SizedBox(
        height: 50.h,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'editAvatar',
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(Global.instance.user!.avatarUrl),
              ),
            ),
            // 20.horizontalSpace,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                // child: Container(
                //   color: Colors.red,
                //   // height: 60.h,
                // ),
                child: LayoutBuilder(builder: (context, constraints) {
                  final text = Global.instance.user?.userName ?? 'User';
                  final painter = TextPainter(
                    text: TextSpan(text: text),
                    maxLines: 1,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    textDirection: TextDirection.ltr,
                  );
                  painter.layout();
                  final overflow = painter.size.width > constraints.maxWidth;

                  return overflow
                      ? SizedBox.expand(
                          child: Marquee(
                              text: text,
                              pauseAfterRound: const Duration(seconds: 3),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500)),
                        )
                      : Text(
                          text,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                }),
              ),
            ),
            // 16.horizontalSpace,
            GestureDetector(
              onTap: () async {
                final result =
                    await context.pushRoute<bool>(const EditInfoRoute());
                if (result != null && result) {
                  setState(() {});
                }
              },
              child: Assets.icons.icEdit.svg(height: 28.h),
            ),
          ],
        ),
      ),
    );
  }
}
