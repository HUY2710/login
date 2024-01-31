import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/widgets/custom_appbar.dart';

@RoutePage()
class OnboardingCreateAvtPersonScreen extends StatelessWidget {
  const OnboardingCreateAvtPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const Stack(
          children: [
            CustomAppBar(title: 'Set avatar'),
          ],
        ),
      ),
    );
  }
}
