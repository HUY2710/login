import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../service/shared_preferences/shared_preferences_manager.dart';
import '../../shared/mixin/ads_mixin.dart';

@RoutePage()
class SplashScreen extends StatefulWidget with AdsMixin {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (mounted) {
      await widget.showAd(context);
    }
    if (mounted) {
      await setInitScreen(context);
    }
    _isInitialized = true;
  }

  Future<void> setInitScreen(BuildContext context) async {
    final bool isFirstLaunch =
        await getIt<SharedPreferencesManager>().getIsFirstLaunch();
    if (isFirstLaunch && context.mounted) {
      AutoRouter.of(context).replace(LanguageRoute(isFirst: true));
    } else {
      AutoRouter.of(context).replace(const MyHomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          //error render
          // ListView()
        ],
      ),
    );
  }
}
