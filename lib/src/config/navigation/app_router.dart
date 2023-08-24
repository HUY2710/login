import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../presentation/presentation.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        // Add Route Page in here
        AutoRoute(page: MyHomeRoute.page, initial: true),
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
