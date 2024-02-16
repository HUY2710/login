import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/mixin/permission_mixin.dart';

class PermissionBody extends StatefulWidget {
  const PermissionBody({super.key});

  @override
  State<PermissionBody> createState() => _PermissionContentState();
}

class _PermissionContentState extends State<PermissionBody>
    with WidgetsBindingObserver, PermissionMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).w,
      child: Column(
        children: [
          SizedBox.square(
            dimension: 150.r,
            child: const Placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(25).r,
            child: const Text(
              'context.l10n.requirePermission',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
