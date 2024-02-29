import UIKit
import Flutter
import FirebaseCore
import google_mobile_ads
import GoogleMaps
import UserNotifications
//import FBAudienceNetwork
//import UnityAds
//import IronSource

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let gmsKey = Bundle.main.object(forInfoDictionaryKey: "GMSServiceKey") as? String {
            GMSServices.provideAPIKey(gmsKey)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        //    FirebaseApp.configure()
        registerAdFactory()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupAdsMediation() {
        // meta ads
//        FBAdSettings.setAdvertiserTrackingEnabled(true)
//        // unity ads
//        let gdprMetaData = UADSMetaData()
//        gdprMetaData.set("gdpr.consent", value: true)
//        gdprMetaData.commit()
//        let ccpaMetaData = UADSMetaData()
//        ccpaMetaData.set("privacy.consent", value: true)
//        ccpaMetaData.commit()
//        // ironSource
//        IronSource.setConsent(true)
//        IronSource.setMetaDataWithKey("do_not_sell", value: "YES")
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
