import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../service/admob/banner_ad_manager.dart';

class AnchoredAdCubit extends Cubit<BannerAd?> {
  AnchoredAdCubit(this.adManager) : super(null);
  final BannerAdManager adManager;

  Future<void> loadAd() async {
    emit(null);
    final BannerAd? bannerAd = await adManager.loadAnchoredAdaptiveAd();
    emit(bannerAd);
  }
}
