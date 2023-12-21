import 'package:auto_route/auto_route.dart';
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
  bool visibleAd = false;
  ValueNotifier<bool> showSkipButton = ValueNotifier(false);

  @override
  void initState() {
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
        bottomNavigationBar: _buildAd(),
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

  Widget _buildAd() {
    if (!visibleAd) {
      return const SizedBox(
        height: 272,
      );
    }
    return LargeNativeAd(
      unitId: getIt<AppAdIdManager>().adUnitId.native,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
