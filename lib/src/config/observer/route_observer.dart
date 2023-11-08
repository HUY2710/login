import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/mixin/system_ui_mixin.dart';
import '../../shared/helpers/logger_utils.dart';

class MainRouteObserver extends AutoRouterObserver with SystemUiMixin {
  @override
  void didPush(Route route, Route? previousRoute) {
    hideNavigationBar();
    logger.d(
      'Did Push',
      'from ${previousRoute?.settings.name} to ${route.settings.name}',
    );
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logger.d(
      'Init',
      route.name,
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    hideNavigationBar();
    logger.d(
      'Change tab',
      'from ${previousRoute.name} to ${route.name}',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    hideNavigationBar();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    hideNavigationBar();
  }
}
