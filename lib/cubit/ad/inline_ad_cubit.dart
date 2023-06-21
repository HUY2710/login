import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../service/admob/ad_manager/banner_ad_manager.dart';

class InlineAdCubit extends Cubit<BannerAd?> {
  InlineAdCubit(this.adManager) : super(null);
  final BannerAdManager adManager;

  Future<void> loadAd() async {
    emit(null);
    final BannerAd? bannerAd = await adManager.loadInlineAdaptiveAd();
    if (bannerAd != null) {
      emit(bannerAd);
    }
  }
}
