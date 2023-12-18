import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/widget/ads/large_native_ad.dart';
import '../../../module/admob/widget/ads/small_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('home'),
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(const SettingRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SmallNativeAd(
              unitId: getIt<AppAdIdManager>().adUnitId.native,
            )
          ],
        ),
      ),
      bottomNavigationBar: LargeNativeAd(
        unitId: getIt<AppAdIdManager>().adUnitId.native,
      ),
    );
  }
}
