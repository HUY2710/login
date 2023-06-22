import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../admob/app_lifecycle_reactor.dart';
import '../../admob/manager/app_open_ad_manager.dart';
import '../../admob/remote_config/remote_config_manager.dart';
import '../../admob/widget/adaptive_ad.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../widgets/app_bar_gone.dart';
import '../widgets/bottom_nav_bar.dart';
import 'first_screen.dart';
import 'second_screen.dart';

class SkeletonScreen extends StatefulWidget {
  const SkeletonScreen({super.key});

  @override
  State<SkeletonScreen> createState() => _SkeletonScreenState();
}

class _SkeletonScreenState extends State<SkeletonScreen> {
  late AppLifecycleReactor _appLifecycleReactor;
  final AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late bool isShowAppOpenAd;

  @override
  void initState() {
    isShowAppOpenAd = RemoteConfigManager.instance.isShowAd(AdKey.open_app);
    if (isShowAppOpenAd) {
      loadAdOnAppStateChange();
    }
    super.initState();
  }


  Future<void> loadAdOnAppStateChange() async {
    await appOpenAdManager.loadAd();

    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> pageNavigation = <Widget>[
      FirstScreen(),
      SecondScreen(),
    ];

    return BlocProvider<BottomNavCubit>(
      create: (BuildContext context) => BottomNavCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const AppBarGone(),

        /// When switching between tabs this will fade the old
        /// layout out and the new layout in.
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<BottomNavCubit, int>(
                builder: (BuildContext context, int state) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: pageNavigation.elementAt(state));
                },
              ),
            ),
            const AdaptiveAdWidget()
          ],
        ),

        bottomNavigationBar: const BottomNavBar(),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
      ),
    );
  }
}
