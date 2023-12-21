import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('home'),
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(const SettingRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
