import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../config/di/di.dart';
import '../../gen/gens.dart';
import '../../services/firebase_message_service.dart';
import '../../shared/extension/context_extension.dart';
import '../onboarding/widgets/app_button.dart';
import 'cubit/sos_cubit.dart';

@RoutePage()
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!getIt<SosCubit>().state) {
      _countdown = 5;
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          getIt<SosCubit>().toggle();
          FirebaseMessageService().sendSOS(context);
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<SosCubit, bool>(
        bloc: getIt<SosCubit>(),
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
            child: AppButton(
                title: state
                    ? context.l10n.cancel
                    : '${context.l10n.cancel} ${context.l10n.alert}',
                onTap: () async {
                  //đang bật sos => tắt sos
                  if (state) {
                    //tiến hành hủy sos
                    await getIt<SosCubit>().toggle();
                  }
                  //sos tắt thì back về
                  context.popRoute();
                }),
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RippleAnimation(
                color: Colors.red,
                delay: const Duration(milliseconds: 150),
                repeat: true,
                minRadius: 25.r,
                ripplesCount: 25,
                duration: const Duration(milliseconds: 6 * 300),
                child: Image.asset(
                  Assets.images.sos.path,
                  height: 150.r,
                  width: 150.r,
                ),
              ),
              16.verticalSpace,
              BlocBuilder<SosCubit, bool>(
                bloc: getIt<SosCubit>(),
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100.r,
                          width: 100.r,
                          child: !state
                              ? Center(
                                  child: Text(
                                    '$_countdown',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.primary,
                                    ),
                                  ),
                                )
                              : Assets.lottie.sosCheck.lottie(
                                  fit: BoxFit.fill,
                                  repeat: false,
                                ),
                        ),
                        Text(
                          state
                              ? context.l10n.sosHasSent
                              : context.l10n.sosTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        10.verticalSpace,
                        SizedBox(
                          height: 70.h,
                          child: Text(
                            state
                                ? context.l10n.sosSend2
                                : context.l10n.sosSend1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xff9E9E9E),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
