import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/mixin/log_mixin.dart';

class MainRouteObserver extends AutoRouterObserver with LogMixin {
  @override
  void didPush(Route route, Route? previousRoute) {
    logD(
        'didPush from ${previousRoute?.settings.name} to ${route.settings.name}');
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logD('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    logD('Tab route re-visited: ${route.name}');
  }
}
