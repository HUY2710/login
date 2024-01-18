package com.vtn.global.base.flutter

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.vtn.global.base.flutter.enum.ButtonPosition
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

import com.unity3d.ads.metadata.MetaData
import com.ironsource.mediationsdk.IronSource

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val windowInsetsController =
            WindowCompat.getInsetsController(window, window.decorView)
        // Configure the behavior of the hidden system bars.
        windowInsetsController?.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

        // unity ads privacy settings
        val gdprMetaData = MetaData(this)
        gdprMetaData["gdpr.consent"] = true
        gdprMetaData.commit()
        val ccpaMetaData = MetaData(this)
        ccpaMetaData["privacy.consent"] = true
        ccpaMetaData.commit()

        // ironSource privacy settings
        IronSource.setConsent(true)
        IronSource.setMetaData("do_not_sell", "true")
    }

    public override fun onResume() {
        super.onResume()
        IronSource.onResume(this)
    }

    public override fun onPause() {
        super.onPause()
        IronSource.onPause(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "TopLargeNative",
            CustomNativeAd(context, buttonPosition = ButtonPosition.Top)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "BottomLargeNative",
            CustomNativeAd(context, buttonPosition = ButtonPosition.Bottom)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "TopSmallNative",
            CustomNativeAd(context, buttonPosition = ButtonPosition.Top, hasMedia = false)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "BottomSmallNative",
            CustomNativeAd(context, buttonPosition = ButtonPosition.Bottom, hasMedia = false)
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
