import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/cubit/native_ad_status_cubit.dart';
import '../../../../src/config/di/di.dart';
import '../../../../src/config/remote_config.dart';
import '../../app_ad_id_manager.dart';
import '../../enum/ad_button_position.dart';
import '../../enum/ad_remote_key.dart';
import '../loading/large_ad_loading.dart';

class LargeNativeAd extends StatefulWidget {
  const LargeNativeAd({
    super.key,
    required this.unitId,
    this.unitIdHigh,
    required this.remoteKey,
    this.buttonPosition = AdButtonPosition.bottom,
    this.maintainSize = false,
    this.height,
  })  : controller = null,
        visible = null;

  const LargeNativeAd.control({
    super.key,
    required this.controller,
    required this.visible,
    this.maintainSize = false,
    this.height,
    this.buttonPosition = AdButtonPosition.bottom,
  })  : unitId = null,
        unitIdHigh = null,
        remoteKey = null;

  final String? unitId;
  final String? unitIdHigh;
  final AdButtonPosition? buttonPosition;
  final NativeAdController? controller;
  final AdRemoteKeys? remoteKey;
  final bool? visible;
  final bool maintainSize;
  final double? height;

  @override
  State<LargeNativeAd> createState() => _LargeNativeAdState();
}

class _LargeNativeAdState extends State<LargeNativeAd> {
  bool visible = false;

  @override
  void initState() {
    if (widget.visible == null && widget.remoteKey != null) {
      visible = RemoteConfigManager.instance.isShowAd(widget.remoteKey!);
    } else {
      visible = widget.visible ?? false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 270;
    if (!visible) {
      return SizedBox(
        height: widget.maintainSize ? height : 0,
      );
    }
    final factoryId = switch (widget.buttonPosition) {
      AdButtonPosition.top => getIt<AppAdIdManager>().topLargeNativeFactory,
      AdButtonPosition.bottom =>
        getIt<AppAdIdManager>().bottomLargeNativeFactory,
      _ => null
    };
    return BlocBuilder<NativeAdStatusCubit, bool>(
      builder: (context, state) {
        return Visibility(
          visible: state,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: buildAd(
            widget.controller != null ? null : factoryId,
            height,
          ),
        );
      },
    );
  }

  Container buildAd(String? factoryId, double height) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            spreadRadius: 0.6,
            blurRadius: 8,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: EasyNativeAd(
        factoryId: factoryId,
        adId: widget.unitId,
        highId: widget.unitIdHigh,
        height: height,
        controller: widget.controller,
        loadingWidget: const LargeAdLoading(),
      ),
    );
  }
}
