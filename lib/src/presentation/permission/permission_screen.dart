import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/cubit/native_ad_status_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/mixin/ads_mixin.dart';
import '../../../module/admob/widget/ads/large_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/mixin/permission_mixin.dart';
import '../../shared/widgets/custom_switch.dart';
import 'cubit/storage_status_cubit.dart';

part 'widget/permission_appbar.dart';
part 'widget/permission_body.dart';

@RoutePage()
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with AdsMixin {
  AppAdIdManager get adManager => getIt<AppAdIdManager>();
  bool isVisibleAd = false;

  @override
  void initState() {
    isVisibleAd = checkVisibleStatus(AdRemoteKeys.native_permission);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoragePermissionCubit(false),
        ),
      ],
      child: Scaffold(
        appBar: PermissionAppbar(
          context,
          onActionTapped: () async {
            await getIt<SharedPreferencesManager>()
                .saveIsPermissionAllow(false);
            if (context.mounted) {
              context.router.replaceAll([const HomeRoute()]);
            }
          },
        ),
        body: const PermissionBody(),
        bottomSheet: isVisibleAd
            ? LargeNativeAd(
                unitId: adManager.adUnitId.nativePermission,
              )
            : null,
      ),
    );
  }
}
