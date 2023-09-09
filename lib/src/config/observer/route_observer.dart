import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/logger_utils.dart';

class MainRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
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
    logger.d(
      'Change tab',
      'from ${previousRoute.name} to ${route.name}',
    );
  }
}
