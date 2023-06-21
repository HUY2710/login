import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../service/admob/ad_manager/native_ad_manager.dart';

class NativeAdCubit extends Cubit<NativeAd?> {
  NativeAdCubit(this.adManager) : super(null);

  final NativeAdManager adManager;

  NativeAd? nativeAd;

  Future<void> loadAd() async {
    emit(null);
    nativeAd = await adManager.loadAd();
    emit(nativeAd);
  }

  void dispose() {
    nativeAd?.dispose();
  }
}
