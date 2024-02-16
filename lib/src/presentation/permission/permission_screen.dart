import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/navigation/app_router.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../onboarding/widgets/app_button.dart';
import 'cubit/storage_status_cubit.dart';

@RoutePage()
class PermissionScreen extends StatelessWidget with PermissionMixin {
  const PermissionScreen({super.key, required this.fromMapScreen});
  final bool fromMapScreen;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoragePermissionCubit(false),
        ),
      ],
      child: Scaffold(
        body: const PermissionBody(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                  title: 'Allow',
                  onTap: () async {
                    await requestPermissionLocation(); //request permission location
                    if (context.mounted && !fromMapScreen) {
                      context.replaceRoute(const HomeRoute());
                    } else if (context.mounted) {
                      context.popRoute();
                    }
                  }),
              TextButton(
                  onPressed: () {
                    if (context.mounted && !fromMapScreen) {
                      context.replaceRoute(const HomeRoute());
                    } else if (context.mounted) {
                      context.popRoute();
                    }
                  },
                  child: const Text('Later'))
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionBody extends StatefulWidget {
  const PermissionBody({super.key});

  @override
  State<PermissionBody> createState() => _PermissionBodyState();
}

class _PermissionBodyState extends State<PermissionBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          100.verticalSpace,
          Image.asset(
            Assets.images.permission.path,
            width: 160.r,
            height: 160.r,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
            child: Text(
              'Cycle sharing requires these permissions to function properly',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: MyColors.black34,
              ),
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.icLocation.path,
                width: 20.r,
                height: 20.r,
              ),
              8.horizontalSpace,
              const Text('Location')
            ],
          ),
          5.verticalSpace,
          Text(
            'Location permissions are set to “always” to allow data to be used for in-app maps, location alerts, and location sharing with your group.',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
