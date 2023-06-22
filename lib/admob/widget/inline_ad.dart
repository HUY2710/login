import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../cubit/inline_ad_cubit.dart';
import '../manager/banner_ad_manager.dart';
import '../remote_config/remote_config_manager.dart';

class InlineAdWidget extends StatefulWidget {
  const InlineAdWidget({super.key, required this.size, this.insets});

  final AdSize size;
  final double? insets;

  @override
  State<InlineAdWidget> createState() => _InlineAdWidgetState();
}

class _InlineAdWidgetState extends State<InlineAdWidget> {
  late InlineAdCubit inlineAdCubit;
  Orientation? _currentOrientation;
  late bool isShowAd;

  @override
  void initState() {
    isShowAd = RemoteConfigManager.instance.isShowAd(AdKey.banner);
    final BannerAdManager bannerAdManager =
    BannerAdManager(context: context, insets: widget.insets ?? 16);
    inlineAdCubit = InlineAdCubit(bannerAdManager);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isShowAd) {
      inlineAdCubit.loadAd(widget.size);
      _currentOrientation = MediaQuery
          .of(context)
          .orientation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InlineAdCubit, BannerAd?>(
      bloc: inlineAdCubit,
      builder: (BuildContext context, BannerAd? state) {
        Widget child;
        if (state != null) {
          child = OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) =>
                buildAdWidget(ad: state, orientation: orientation),
          );
        } else {
          child = const SizedBox();
        }
        return child;
      },
    );
  }

  Widget buildAdWidget(
      {required BannerAd ad, required Orientation orientation}) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (_currentOrientation == orientation) {
          return SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(
              ad: ad,
            ),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          inlineAdCubit.loadAd(widget.size);
        }
        return Container();
      },
    );
  }
}
