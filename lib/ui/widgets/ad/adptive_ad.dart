import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../cubit/anchored_ad_cubit.dart';

class AdaptiveAdWidget extends StatefulWidget {
  const AdaptiveAdWidget({super.key});

  @override
  State<AdaptiveAdWidget> createState() => _AdaptiveAdWidgetState();
}

class _AdaptiveAdWidgetState extends State<AdaptiveAdWidget> {
  @override
  void initState() {
    context.read<AnchoredAdCubit>().loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnchoredAdCubit, BannerAd?>(
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
