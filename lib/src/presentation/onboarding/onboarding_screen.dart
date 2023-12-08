import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/mixin/ads_mixin.dart';
import '../../../module/admob/widget/ads/large_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
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

class _OnBoardingScreenState extends State<OnBoardingScreen> with AdsMixin {
  final PageController _pageController = PageController();
  bool visibleAd = false;

  @override
  void initState() {
    context.read<LanguageCubit>().update(widget.language);
    // visibleAd = checkVisibleStatus(AdRemoteKeys.native_intro);
    super.initState();
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
              child: OnboardingCarousel(pageController: _pageController),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<ValueCubit<int>, int>(
                builder: (context, currentIndex) => ActionRow(
                  pageController: _pageController,
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
