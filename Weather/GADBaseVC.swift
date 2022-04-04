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
    public lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        return banner
    }()
}

extension GADBaseVC: GADBannerViewDelegate {
    func setupBannerViewToBottom(height: CGFloat = 50) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
        bannerView = GADBannerView(adSize: adSize)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: height)
        ])

        bannerView.adUnitID = Keys.GoogleTestAD.testBannerADKey
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    
    // MARK: - Delegate
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
