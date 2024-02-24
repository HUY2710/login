import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/navigation/app_router.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../onboarding/widgets/app_button.dart';
import 'widget/permission_content.dart';

@RoutePage()
class PermissionScreen extends StatelessWidget with PermissionMixin {
  const PermissionScreen({super.key, required this.fromMapScreen});
  final bool fromMapScreen;

  @override
  Widget build(BuildContext context) {
    final ValueCubit<bool?> locationCubit = ValueCubit(null);
    final ValueCubit<bool?> notifyCubit = ValueCubit(null);
    final ValueCubit<bool?> motionCubit = ValueCubit(null);
    final ValueCubit<int> typeRequest = ValueCubit(1);

    final ValueCubit<bool> showNotify = ValueCubit(false);
    final ValueCubit<bool> showMotion = ValueCubit(false);
    //1 request location
    //2 request notification
    //3 request motion
    return Scaffold(
      body: PermissionContent(
        locationCubit: locationCubit,
        notifyCubit: notifyCubit,
        motionCubit: motionCubit,
        typeRequest: typeRequest,
        showMotion: showMotion,
        showNotify: showNotify,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ValueCubit<int>, int>(
              bloc: typeRequest,
              builder: (context, state) {
                return AppButton(
                    title: 'Allow',
                    onTap: () async {
                      if (state == 1) {
                        final status = await requestPermissionLocation();
                        locationCubit.update(status);
                        showNotify.update(true);
                        typeRequest.update(2);
                      }

                      if (state == 2) {
                        final status = await requestNotification();
                        notifyCubit.update(status);
                        showMotion.update(true);
                        typeRequest.update(3);
                      }
                      if (state == 3) {
                        final status = await requestActivityRecognition();
                        if (status) {}
                        motionCubit.update(status);
                        typeRequest.update(0); //không request nữa
                        context.router.replaceAll([const HomeRoute()]);
                      }
                    });
              },
            ),
            TextButton(
              onPressed: () {
                if (context.mounted && !fromMapScreen) {
                  context.replaceRoute(const HomeRoute());
                } else if (context.mounted) {
                  context.popRoute();
                }
              },
              child: const Text('Later'),
            )
          ],
        ),
      ),
    );
  }
}
