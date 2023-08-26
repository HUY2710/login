import UIKit
import Flutter
import FirebaseCore
import google_mobile_ads
import FBAudienceNetwork
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FBAdSettings.setAdvertiserTrackingEnabled(true)
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
