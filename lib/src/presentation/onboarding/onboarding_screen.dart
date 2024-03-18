import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/language.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../sign_in/cubit/join_anonymous_cubit.dart';
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

  Future<void> navigateToNextScreen() async {
    await SharedPreferencesManager.saveIsStarted(false);

    final isCreateInfoFirstTime =
        await SharedPreferencesManager.getIsCreateInfoFistTime();
    if (mounted) {
      if (isCreateInfoFirstTime) {
        context.replaceRoute(const CreateUsernameRoute());
      } else {
        final bool statusLocation = await checkPermissionLocation().isGranted;
        if (!statusLocation && context.mounted) {
          context.replaceRoute(PermissionRoute(fromMapScreen: false));
          return;
        } else if (context.mounted) {
          final showGuide = await SharedPreferencesManager.getGuide();
          if (showGuide && context.mounted) {
            context.replaceRoute(const GuideRoute());
          } else if (context.mounted) {
            // context.replaceRoute(HomeRoute());
            context.replaceRoute(PremiumRoute(fromStart: true));
          }
        }
      }
    }
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
                        onPressed: () async {
                          final isLogin =
                              await SharedPreferencesManager.getIsLogin();
                          context.pushRoute(const AuthLoginRoute());
                          // if (isLogin) {
                          //   navigateToNextScreen();
                          // } else {

                          // }
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.zero)),
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
                  onStartedTap: () {
                    context.pushRoute(const AuthLoginRoute());
                  },
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
