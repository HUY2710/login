import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../admob/cubit/native_ad_cubit.dart';
import '../manager/native_ad_manager.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({
    super.key,
    required this.templateType,
  });

  final TemplateType templateType;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late NativeAdCubit nativeAdCubit;

  @override
  void initState() {
    nativeAdCubit = NativeAdCubit(NativeAdManager(widget.templateType));

    nativeAdCubit.loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NativeAdCubit, NativeAd?>(
      bloc: nativeAdCubit,
      builder: (BuildContext context, NativeAd? state) {
        Widget child;
        if (state != null) {
          final BoxConstraints boxConstraints = getBoxConstraint(state);
          child = ConstrainedBox(
            constraints: boxConstraints,
            child: AdWidget(ad: state),
          );
        } else {
          child = const SizedBox();
        }
        return child;
      },
    );
  }

  BoxConstraints getBoxConstraint(NativeAd ad) {
    final TemplateType? templateType = ad.nativeTemplateStyle?.templateType;
    BoxConstraints boxConstraints;
    if (templateType == TemplateType.small) {
      boxConstraints = const BoxConstraints(
        minWidth: 320, // minimum recommended width
        minHeight: 90, // minimum recommended height
        maxWidth: 400,
        maxHeight: 200,
      );
    } else {
      boxConstraints = const BoxConstraints(
        minWidth: 320, // minimum recommended width
        minHeight: 320, // minimum recommended height
        maxWidth: 400,
        maxHeight: 400,
      );
    }
    return boxConstraints;
  }

  @override
  void dispose() {
    nativeAdCubit.dispose();
    super.dispose();
  }
}
