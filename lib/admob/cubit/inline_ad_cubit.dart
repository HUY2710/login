import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../manager/banner_ad_manager.dart';

class InlineAdCubit extends Cubit<BannerAd?> {
  InlineAdCubit(this.adManager) : super(null);
  final BannerAdManager adManager;

  Future<void> loadAd(AdSize size) async {
    emit(null);
    final BannerAd? bannerAd = await adManager.loadInlineAdaptiveAd(size);
    if (bannerAd != null) {
      emit(bannerAd);
    }
  }
}
