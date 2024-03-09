import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/config/di/di.dart';
import '../../../../src/config/remote_config.dart';
import '../../../../src/presentation/home/cubit/banner_collapse_cubit.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_remote_key.dart';
import 'banner_ad.dart';

class BuildBannerWidget extends StatelessWidget {
  const BuildBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isShow =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.banner_all);

    return BlocBuilder<BannerCollapseAdCubit, bool>(
      bloc: getIt<BannerCollapseAdCubit>(),
      builder: (context, state) {
        return Visibility(
          maintainState: true,
          visible: state && isShow,
          child: MyBannerAd(
            id: getIt<AppAdIdManager>().adUnitId.bannerAll,
          ),
        );
      },
    );
  }
}
