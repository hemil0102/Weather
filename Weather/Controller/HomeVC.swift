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
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var currStateLabel: UILabel!
    @IBOutlet weak var currWeatherBackground: UIImageView!
    @IBOutlet weak var currWeatherLabel: UILabel!
    
    //Model
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var parseCSV = ParsingCSV()
    var model: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        setupBannerViewToBottom()       //[Walter] 하단 적응형 광고 띄우기
        configureCurrWeatherViews()         //[Walter] View 모양 설정
        
        self.locationManager.delegate = self
        self.weatherManager.delegate = self
        
        //DateTime Format
//        let dateFormatter = DateFormatter()
//        let date = Date(timeIntervalSinceReferenceDate: 1649412000)
//
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdHHmm") // set template after setting locale
//        print(dateFormatter.string(from: date))
    }
    
    //날씨 배경 모서리 둥글게
    func configureCurrWeatherViews() {
        currWeatherBackground.layer.cornerRadius = 15
    }
    
    //현재 위치 좌표 가져오기 호출
    @IBAction func currLocationWeatherBtnAct(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - UITabBarControllerDelegate
extension HomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("탭 번호 \(tabBarController.selectedIndex)")
        guard let weatherTab = viewController as? WeatherVC else { return }
        if let model = model {
            print("modelllll \(model.currWeather.temp)")
//            weatherTab.wModel = model
        }
    }
}

// MARK: - WeatherManager Delegate
extension HomeVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        self.model = weather
        DispatchQueue.main.async {
            //Update Views
            let si = weather.si
            let dong = weather.dong
            let cTemp = weather.currWeather.temp
            let cHumidity = weather.currWeather.humidity
//            let cWind_speed = weather.currWeather.wind_speed
            let cCloud = weather.currWeather.clouds
            let cDescription = weather.currWeather.description
            
            self.placeNameLabel.text = "\(si) \(dong)"
            self.currStateLabel.text = "\(cDescription)"
            self.currWeatherLabel.text = "온도 \(cTemp)℃/ 습도 \(cHumidity)%/ 강우량 \(cCloud)%"
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류!!! \(error)")
    }
}

// MARK: - CLLocation Delegate 현재 위치 날씨 가져올 때 사용
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            //GPS 권한을 받지 못함
            print("권한을 받지 못한 상태")
            locationManager.requestWhenInUseAuthorization()
        case .denied, .authorized:
            //GPS 권한 요청을 거부함
            print("권한 요청을 거부함")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            //GPS 권한 요청을 수락
            print("권한 얻음")
            weatherManager.getWeatherWithName(name: "구운동")
        default:
            break
        }
    }
    
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
