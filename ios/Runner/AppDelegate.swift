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
            self, factoryId: "TopLargeNative", nativeAdFactory: CustomNativeAdFactory())
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "BottomLargeNative", nativeAdFactory: CustomNativeAdFactory(buttonPosition: ButtonPosition.Bottom))
        
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "TopSmallNative", nativeAdFactory: CustomNativeAdFactory(hasMedia: false))
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "BottomSmallNative", nativeAdFactory: CustomNativeAdFactory(buttonPosition: ButtonPosition.Bottom, hasMedia: false))
        
    }
}
