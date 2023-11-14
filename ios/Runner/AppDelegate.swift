import UIKit
import Flutter
import FirebaseCore
import google_mobile_ads
import FBAudienceNetwork
import UnityAds
import IronSource
import VungleAdsSDK
import VungleAdapter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        // meta ads
        FBAdSettings.setAdvertiserTrackingEnabled(true)
        // unity ads
        let gdprMetaData = UADSMetaData()
        gdprMetaData.set("gdpr.consent", value: true)
        gdprMetaData.commit()
        let ccpaMetaData = UADSMetaData()
        ccpaMetaData.set("privacy.consent", value: true)
        ccpaMetaData.commit()
        // ironSource
        IronSource.setConsent(true)
        IronSource.setMetaDataWithKey("do_not_sell", value: "YES")
        // vungle/liftoff
        VunglePrivacySettings.setGDPRStatus(true)
        VunglePrivacySettings.setGDPRMessageVersion("v1.0.0")
        VunglePrivacySettings.setCCPAStatus(true)

        let request = GADRequest()
        let extras = VungleAdNetworkExtras()

        let placements = ["PLACEMENT_ID_1", "PLACEMENT_ID_2"]
        extras.allPlacements = placements
        request.register(extras)


    GeneratedPluginRegistrant.register(with: self)
//    FirebaseApp.configure()
    registerAdFactory()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerAdFactory() {
          FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
                  self, factoryId: "LargeNative", nativeAdFactory: LargeNativeAdFactory())

          FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
                  self, factoryId: "SmallNative", nativeAdFactory: SmallNativeAdFactory())

          FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
                  self, factoryId: "NonMediaBottomNative", nativeAdFactory: NonMediaBottomNativeAdFactory())

          FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
                  self, factoryId: "NonMediaTopNative", nativeAdFactory: NonMediaTopNativeAdFactory())
      }
}
