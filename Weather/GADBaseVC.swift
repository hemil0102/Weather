//
//  BaseVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//
// 타 사이트 참고

import Foundation
import GoogleMobileAds

class GADBaseVC: UIViewController {
    lazy var bannerView: GADBannerView = {
        let banner = GADBannerView()
        return banner
    }()
}

extension GADBaseVC: GADBannerViewDelegate {
    func setupBannerViewToBottom() {

//        NSLayoutConstraint.activate([
//            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            bannerView.heightAnchor.constraint(equalToConstant: height)
//        ])
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
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
        
        
        bannerView.adUnitID = Keys.GoogleTestAD.testBannerADKey
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    //[Walter] 적응형 배너 광고
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }

    func loadBannerAd() {
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width

        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        print("bnnerView 하단 Size : \(bannerView.adSize.size.height)")

        // Step 4 - Create an ad request and load the adaptive banner ad.
        bannerView.load(GADRequest())
    }
}
