import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/helpers/logger_utils.dart';
import '../../shared/mixin/system_ui_mixin.dart';

class MainRouteObserver extends AutoRouteObserver with SystemUiMixin {
  @override
  void didPush(Route route, Route? previousRoute) {
    hideNavigationBar();
    logger.d(
      'Did Push',
      error: 'from ${previousRoute?.settings.name} to ${route.settings.name}',
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logger.d(
      'Init',
      error: route.name,
    );
    super.didInitTabRoute(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    hideNavigationBar();
    logger.d(
      'Change tab',
      error: 'from ${previousRoute.name} to ${route.name}',
    );
    super.didChangeTabRoute(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    hideNavigationBar();
    super.didReplace();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    hideNavigationBar();
    super.didPop(route, previousRoute);
  }
}
