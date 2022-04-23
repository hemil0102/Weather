//
//  BaseVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//
// 타 사이트 참고

import Foundation
import GoogleMobileAds
import UIKit

class GADBaseVC: UIViewController {
    var vProgress: UIView?
    
    lazy var bannerView: GADBannerView = {
        let banner = GADBannerView()
        return banner
    }()
}

extension GADBaseVC {
    // MARK: [원형 프로그레스 시작 메소드]
    // [호출 방법 : self.progressStart(onView: self.view)]
    func progressStart(onView : UIView) {
        print("")
        print("===============================")
        print("[S_Extension >> progressStart() :: 로딩 프로그레스 시작 실시]")
        print("===============================")
        print("")
        
        let progressView = UIView.init(frame: onView.bounds)
        // [프로그레스를 담는 부모 뷰 : 검정색]
        progressView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()       // [Indicator : 원형 프로그레스 생성 실시]
        //activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)    // [사이즈 지정 실시]
        activityIndicator.center = progressView.center      // [위치 지정 실시]
        activityIndicator.color = UIColor.white             // [색상 지정 실시]
        activityIndicator.hidesWhenStopped = true           // [hidden 시 애니메이션 종료 여부 지정]
        activityIndicator.style = UIActivityIndicatorView.Style.medium      // [스타일 지정 실시]
    
        activityIndicator.startAnimating()      // [애니메이션 시작 수행]
        
        // [비동기 ui 처리 수행 실시]
        DispatchQueue.main.async {
            progressView.addSubview(activityIndicator) // 부모에 Indicator 자식 추가
            onView.addSubview(progressView) // 뷰컨트롤러에 부모 추가
        }
        vProgress = progressView
    }
    
    // MARK: [원형 프로그레스 종료 메소드]
    // [호출 방법 : self.progressStop()]
    func progressStop() {
        print("")
        print("===============================")
        print("[S_Extension >> progressStop() :: 로딩 프로그레스 종료 실시]")
        print("===============================")
        print("")
        DispatchQueue.main.async {
            self.vProgress?.removeFromSuperview() // 뷰에서 제거 실시
            self.vProgress = nil
        }
    }
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
