import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/language.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/permission_mixin.dart';
import 'widgets/app_button.dart';
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

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with PermissionMixin {
  final PageController _pageController = PageController();

  @override
  void initState() {
    context.read<LanguageCubit>().update(widget.language);
    super.initState();
  }

  //vì màn onboard chỉ chạy 1 lần
  Future<void> navigateToNextScreen() async {
    await SharedPreferencesManager.saveIsFirstLaunch(false);
    if (context.mounted) {
      context.replaceRoute(const SignInRoute());
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValueCubit<int>(0),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  OnboardingCarousel(pageController: _pageController),
                  Positioned(
                      top: ScreenUtil().statusBarHeight,
                      right: 10,
                      child: TextButton(
                        onPressed: navigateToNextScreen,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero,
                          ),
                        ),
                        child: Text(
                          context.l10n.skip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ))
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
