import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../gen/gens.dart';
import '../onboarding/widgets/app_button.dart';

@RoutePage()
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  late int _countdown;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _countdown = 5;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          // Put your code here to handle when countdown reaches 0
          // For example, navigate to another screen
          // context.router.replace(const AnotherScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        child: AppButton(
            title: 'Cancel Alert',
            onTap: () {
              context.popRoute();
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RippleAnimation(
            color: Colors.red,
            delay: const Duration(milliseconds: 150),
            repeat: true,
            minRadius: 16,
            ripplesCount: 20,
            duration: const Duration(milliseconds: 6 * 300),
            child: Image.asset(
              Assets.images.sos.path,
              height: 184.h,
              width: 184.r,
            ),
          ),
          Text(
            '$_countdown',
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
          ),
          10.verticalSpace,
          const Text('Sending SOS Alert...'),
          10.verticalSpace,
          const Text(
            'Send an SOS alert to your friends in case of emergency',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
