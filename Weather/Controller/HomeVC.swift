//
//  ViewController.swift
//  Weather
//
//  Created by Walter J on 2022/04/01.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {
    
    //광고
    var bannerView: GADBannerView!
//    var banner = GADBaseVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Walter] Test중..
//        banner.setupBannerViewToBottom()
        
        //[Walter] 광고
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = Keys.GoogleTestAD.testBannerADKey
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}

