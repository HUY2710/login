//
//  CustomNativeAdFactory.swift
//  Runner
//
//  Created by VTN Dev on 11/12/2023.
//

import Foundation
import google_mobile_ads

class CustomNativeAdFactory: FLTNativeAdFactory {
    var buttonPosition : ButtonPosition
    var hasMedia : Bool
    init(buttonPosition: ButtonPosition = ButtonPosition.Top, hasMedia: Bool = true) {
        self.buttonPosition = buttonPosition
        self.hasMedia = hasMedia
    }
    

    func createNativeAd(_ nativeAd: GADNativeAd,
        customOptions: [AnyHashable: Any]? = nil) -> GADNativeAdView? {
        let viewName = buttonPosition == ButtonPosition.Top ? "TopNativeAdView" : "BottomNativeAdView"
        let nibView = Bundle.main.loadNibNamed(viewName, owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADNativeAdView

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        if(hasMedia){
            nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        } else{
            nativeAdView.mediaView?.isHidden = true
            nativeAdView.mediaView?.removeFromSuperview()
        }
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        let actionButton = nativeAdView.callToActionView as? UIButton
        actionButton?.setTitle(nativeAd.callToAction, for: .normal)
        actionButton?.layer.cornerRadius = 8
        actionButton?.layer.masksToBounds = true
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }

}
