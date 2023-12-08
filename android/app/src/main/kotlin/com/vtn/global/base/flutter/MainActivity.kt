package com.vtn.global.base.flutter

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.vtn.global.base.flutter.enum.ButtonPosition
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val windowInsetsController =
            WindowCompat.getInsetsController(window, window.decorView)
        // Configure the behavior of the hidden system bars.
        windowInsetsController.systemBarsBehavior =
            WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "TopLargeNative",
            CommonNativeAd(context, buttonPosition = ButtonPosition.Top)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "BottomLargeNative",
            CommonNativeAd(context, buttonPosition = ButtonPosition.Bottom)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "TopSmallNative",
            SmallNativeAd(context, buttonPosition = ButtonPosition.Top)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "BottomSmallNative",
            SmallNativeAd(context, buttonPosition = ButtonPosition.Bottom)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "TopLargeNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "BottomLargeNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "TopSmallNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "BottomSmallNative")
    }
}
