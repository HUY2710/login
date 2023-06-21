import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../cubit/ad/inline_ad_cubit.dart';
import '../../../service/admob/ad_manager/banner_ad_manager.dart';

class InlineAdWidget extends StatefulWidget {
  const InlineAdWidget({super.key});

  @override
  State<InlineAdWidget> createState() => _InlineAdWidgetState();
}

class _InlineAdWidgetState extends State<InlineAdWidget> {
  late InlineAdCubit inlineAdCubit;
  late Orientation _currentOrientation;

  @override
  void initState() {
    inlineAdCubit = InlineAdCubit(BannerAdManager(context: context));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inlineAdCubit.loadAd();
    _currentOrientation = MediaQuery.of(context).orientation;
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
          inlineAdCubit.loadAd();
        }
        return Container();
      },
    );
  }
}
