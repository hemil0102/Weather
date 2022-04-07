//
//  ViewController.swift
//  Weather
//
//  Created by Walter J on 2022/04/01.
//

import UIKit
import GoogleMobileAds
import CoreLocation

class HomeVC: GADBaseVC {
    //Views
    //현재 날씨 정보 뷰들
    @IBOutlet weak var currWeatherBackground: UIImageView!
    @IBOutlet weak var currWeatherLabel: UILabel!
    
    //Model
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var parseCSV = ParsingCSV()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBannerViewToBottom()       //[Walter] 하단 적응형 광고 띄우기
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        //csv 파싱
        parseCSV.getDataCsvAt()
//        parseCSV.searchUserKeyword(place: "구운동")
        
        weatherManager.getWeatherWithName(name: "구운동")
    }
    
    //날씨 배경 모서리 둥글게
    func configureCurrWeatherViews() {
        currWeatherBackground.layer.cornerRadius = 15
    }
    
    @IBAction func currLocationWeatherBtnAct(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - WeatherManager Delegate
extension HomeVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        DispatchQueue.main.async {
            //Update Views
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류!!! \(error)")
    }
}

// MARK: - CLLocation Delegate 현재 위치 날씨 가져올 때 사용
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
//            print("위치 정보 : 경도\(lat), 위도\(lon)")
            
            //현재 위치 정보를 기반으로 지역 검색
            weatherManager.getWeatherWithCoordinate(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("현재 위치 가져오기 오류 : \(error)")
    }
}
