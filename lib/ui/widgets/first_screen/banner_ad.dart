import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../cubit/banner_ad_cubit.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  @override
  void initState() {
    context.read<BannerAdCubit>().loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerAdCubit, BannerAd?>(
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
