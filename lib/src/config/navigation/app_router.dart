import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/language/screen/language_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/setting/about_screen.dart';
import '../../presentation/setting/setting_screen.dart';
import '../../presentation/splash/splash_screen.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LanguageRoute.page),
        AutoRoute(page: OnBoardingRoute.page),
        AutoRoute(page: MyHomeRoute.page),
      ];

  AutoRoute routeWithFadeTransition(
      {required PageInfo<void> page, bool initial = false}) {
    return CustomRoute(
      page: page,
      initial: initial,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
