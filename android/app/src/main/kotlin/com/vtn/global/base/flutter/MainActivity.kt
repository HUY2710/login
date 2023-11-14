package com.vtn.global.base.flutter

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

import com.unity3d.ads.metadata.MetaData
import com.ironsource.mediationsdk.IronSource
import com.vungle.warren.Vungle

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

        // vungle/liftoff privacy settings
        Vungle.updateConsentStatus(Vungle.Consent.OPTED_IN, "1.0.0")
        Vungle.updateCCPAStatus(Vungle.Consent.OPTED_IN)
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
            flutterEngine, "LargeNative", CommonNativeAd(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "SmallNative", SmallNativeAd(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "NonMediaBottomNative", NonMediaBottomNativeAd(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "NonMediaTopNative", NonMediaTopNativeAd(context)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "LargeNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "SmallNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "NonMediaBottomNative")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "NonMediaTopNative")
    }
}
