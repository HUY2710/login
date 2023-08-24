import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../service/shared_preferences/shared_preferences_manager.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool isFirstLaunch =
          await getIt<SharedPreferencesManager>().getIsFirstLaunch();
      if (isFirstLaunch && context.mounted) {
        AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
      } else {
        AutoRouter.of(context).replace(const MyHomeRoute());
      }
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
