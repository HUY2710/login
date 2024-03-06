import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/widget/ads/banner_ad.dart';
import '../../config/di/di.dart';
import '../../config/remote_config.dart';
import '../map/map_screen.dart';
import 'cubit/banner_collapse_cubit.dart';
import 'widgets/bottom_sheet/checkin/checkin.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.latLng});

  final Map<String, double>? latLng;
  Widget _buildAd() {
    return BlocBuilder<BannerCollapseAdCubit, bool>(
      bloc: getIt<BannerCollapseAdCubit>(),
      builder: (context, state) {
        return Visibility(
          maintainState: true,
          visible: state,
          child: MyBannerAd(
            id: getIt<AppAdIdManager>().adUnitId.bannerCollapseHome,
            isCollapsible: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isShow = RemoteConfigManager.instance
        .isShowAd(AdRemoteKeys.banner_collapse_home);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: isShow ? _buildAd() : null,
      body: Stack(
        children: [
          MapScreen(
            latLng: latLng,
            showAd: isShow,
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight == 0
                ? 20.h
                : ScreenUtil().statusBarHeight,
            left: 16.w,
            right: 70.w,
            child: const CheckInWidget(),
          ),
        ],
      ),
    );
  }
}
