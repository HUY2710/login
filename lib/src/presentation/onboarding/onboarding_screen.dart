import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/widget/ads/large_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/language.dart';
import '../../shared/extension/context_extension.dart';
import 'widgets/indicator.dart';
import 'widgets/page_widget.dart';

part 'widgets/action_row.dart';
part 'widgets/onboarding_carousel.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key, required this.language});

  final Language language;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  bool visibleAd = true;
  ValueNotifier<bool> showSkipButton = ValueNotifier(false);
  late final controller1 = NativeAdController(
    adId: getIt<AppAdIdManager>().adUnitId.native,
    factoryId: getIt<AppAdIdManager>().bottomLargeNativeFactory,
  );
  late final controller2 = NativeAdController(
    adId: getIt<AppAdIdManager>().adUnitId.native,
    factoryId: getIt<AppAdIdManager>().bottomLargeNativeFactory,
  );
  late final controller3 = NativeAdController(
    adId: getIt<AppAdIdManager>().adUnitId.native,
    factoryId: getIt<AppAdIdManager>().bottomLargeNativeFactory,
  );

  @override
  void initState() {
    controller1.load();
    controller2.load();
    controller3.load();
    context.read<LanguageCubit>().update(widget.language);
    checkShowSkipButton();
    super.initState();
  }

  Future<void> checkShowSkipButton() async {
    final bool isStarted = await SharedPreferencesManager.getIsStarted();
    final bool showButton =
        RemoteConfigManager.instance.isShowSkipIntroButton();
    showSkipButton.value = !isStarted && showButton;
  }

  Future<void> navigateToNextScreen() async {
    await SharedPreferencesManager.saveIsStarted(false);
    final bool isPermissionAllow =
        await SharedPreferencesManager.getIsPermissionAllow();
    if (mounted) {
      if (!isPermissionAllow) {
        context.replaceRoute(const PermissionRoute());
      } else {
        context.replaceRoute(const HomeRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValueCubit<int>(0),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BlocBuilder<ValueCubit<int>, int>(
          builder: (context, state) {
            return switch (state) {
              0 => _buildAd(controller1),
              1 => _buildAd(controller2),
              _ => _buildAd(controller3),
            };
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  OnboardingCarousel(pageController: _pageController),
                  Positioned(
                    top: ScreenUtil().statusBarHeight,
                    left: 5,
                    child: ValueListenableBuilder(
                      valueListenable: showSkipButton,
                      builder: (context, value, child) {
                        if (!value) {
                          return const SizedBox();
                        }
                        return TextButton(
                          onPressed: navigateToNextScreen,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<ValueCubit<int>, int>(
                builder: (context, currentIndex) => ActionRow(
                  pageController: _pageController,
                  onStartedTap: navigateToNextScreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAd(NativeAdController controller) {
    if (!visibleAd) {
      return const SizedBox(
        height: 272,
      );
    }
    return LargeNativeAd(
      controller: controller,
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
