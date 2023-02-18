

//  AdBanner.swift
//
//  Created by Tomoaki Yagishita on 2022/03/11.
//  Copyright © 2022 SmallDeskSoftware. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleMobileAds

//本番用広告
//let MyId = "ca-app-pub-2703588762705717/7933604376"
//テスト用広告
let MyId = "ca-app-pub-3940256099942544/2934735716"

let screenWidth = Int(UIScreen.main.bounds.width)




struct AdBanner: UIViewControllerRepresentable {
    let adUnitId: String
    let widthSize:Int
    let heightSize:Int
    
    private var adSize: GADAdSize {
        return GADAdSizeFromCGSize(CGSize(width: widthSize, height: heightSize))    //kGADAdSizeLargeBanner
    }
    
    func expectedFrame() -> some View {
        let size = adSize.size
        return frame(width: size.width, height: size.height, alignment: .center)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID, "Your-own-device-id" ]
        let view = GADBannerView(adSize: adSize)
        let viewController = UIViewController()
#if DEBUG
        view.adUnitID = adUnitId
#else
        view.adUnitID = adUnitId
#endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame.size = adSize.size
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}




