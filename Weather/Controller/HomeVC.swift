//
//  ViewController.swift
//  Weather
//
//  Created by Walter J on 2022/04/01.
//

import UIKit
import GoogleMobileAds
import SnapKit
import SystemConfiguration

class HomeVC: UIViewController {
    
    //광고
    var bannerView: GADBannerView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var testScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[Harry] TransparentView 사이즈 아이폰 기기에 맞게 조정
        transparentView.frame.size.width = 414
        
        
        //[Walter] 일반 배너 광고
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = Keys.GoogleTestAD.testBannerADKey
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
    }
    
    //[Walter] 일반 배너 광고
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

