import UIKit
import Flutter
import FirebaseCore
import google_mobile_ads
import FBAudienceNetwork
import UnityAds

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
