import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../gen/assets.gen.dart';
import '../../service/app_ad_id_manager.dart';
import '../../service/shared_preferences/shared_preferences_manager.dart';
import '../../shared/enum/ads/ad_remote_key.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/ads_mixin.dart';
import '../../shared/widgets/ads/large_native_ad.dart';
import 'widgets/indicator.dart';
import 'widgets/page_widget.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget with AdsMixin {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  late bool visibleAd;

  @override
  void initState() {
    visibleAd = widget.checkVisibleAd(AdRemoteKeys.native_intro);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: _buildAd(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              children: <Widget>[
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding1,
                  title: 'context.l10n.yourLocation',
                  description: 'context.l10n.subYourLocation',
                ),
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding2,
                  title: 'context.l10n.locationOfFriends',
                  description: 'context.l10n.subLocationFriends',
                ),
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding3,
                  title: 'context.l10n.seeTheirLocationHistory',
                  description: 'context.l10n.subSeeLocationHistory',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: buildIndicator(context, 3, currentIndex),
                ),
                TextButton(
                  onPressed: currentIndex < 2 ? _pressNextButton : _done,
                  child: Text(
                    currentIndex > 1 ? 'Started' : 'Next',
                    style: TextStyle(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAd() {
    if (visibleAd) {
      return LargeNativeAd(
        unitId: getIt<AppAdIdManager>().adUnitId.nativeIntro,
      );
    } else {
      return SizedBox(
        height: 200.h,
      );
    }
  }

  void _pressNextButton() {
    setState(() {
      if (currentIndex < 2) {
        currentIndex++;
        if (currentIndex < 3) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  Future<void> _done() async {
    final bool isVisible = await _checkVisibleInterAd();
    if (isVisible) {
      await _showInterAd();
      await getIt<SharedPreferencesManager>().saveIsStarted(false);
    }
    if (mounted) {
      context.replaceRoute(const MyHomeRoute());
    }
  }

  Future<void> _showInterAd() async {
    await widget.showInterAd(context,
        id: getIt<AppAdIdManager>().adUnitId.interIntro);
  }

  Future<bool> _checkVisibleInterAd() async {
    final bool isStarted =
        await getIt<SharedPreferencesManager>().getIsStarted();
    final bool isShowAd = widget.checkVisibleAd(AdRemoteKeys.inter_intro);
    return isStarted && isShowAd;
  }
}
