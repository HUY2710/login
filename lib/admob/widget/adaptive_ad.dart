import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../cubit/anchored_ad_cubit.dart';
import '../manager/banner_ad_manager.dart';

class AdaptiveAdWidget extends StatefulWidget {
  const AdaptiveAdWidget({super.key, this.insets});

  final double? insets;

  @override
  State<AdaptiveAdWidget> createState() => _AdaptiveAdWidgetState();
}

class _AdaptiveAdWidgetState extends State<AdaptiveAdWidget> {
  late AnchoredAdCubit anchoredAdCubit;

  @override
  void initState() {
    final BannerAdManager bannerAdManager =
        BannerAdManager(context: context, insets: widget.insets);
    anchoredAdCubit = AnchoredAdCubit(bannerAdManager);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    anchoredAdCubit.loadAd();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnchoredAdCubit, BannerAd?>(
      bloc: anchoredAdCubit,
      builder: (BuildContext context, BannerAd? state) {
        Widget child;
        if (state != null) {
          child = SizedBox(
              width: state.size.width.toDouble(),
              height: state.size.height.toDouble(),
              child: AdWidget(ad: state));
        } else {
          child = const SizedBox();
        }

        return child;
      },
    );
  }
}
