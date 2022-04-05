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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupBannerViewToBottom()       //[Walter] 하단 적응형 광고 띄우기
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
//        weatherManager.getCurrWeather(cityName: "suwon")       //[Walter] 입력샘플
    }
    
    func configureCurrWeatherViews() {
        currWeatherBackground.layer.cornerRadius = 15
    }
}

// MARK: - WeatherManager Delegate
extension HomeVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        DispatchQueue.main.async {
            //Update Views
            let name = weather.name
            let currTemp = weather.temp
            let minTemp = weather.temp_min
            let maxTemp = weather.temp_max
            let humidity = weather.humidity
            let conditionId = weather.conditionId
            let description = weather.description
            
            self.currWeatherLabel.text = "온도 \(currTemp)℃ / 습도 \(humidity)% / 풍량 동서 3m/s / 강우량 20%"
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류!!! \(error)")
    }
}

// MARK: - CLLocation Delegate
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            //현재 위치 정보를 기반으로 지역 검색
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("현재 위치 가져오기 오류 : \(error)")
    }
}
