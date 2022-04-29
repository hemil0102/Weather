//
//  SplashVC.swift
//  Weather
//
//  Created by Walter J on 2022/04/25.
//

import Foundation
import UIKit
import CoreLocation

class SplashVC: UIViewController {
    private let locationManager = CLLocationManager()       //[Walter] Get 현재 위치(좌표)
    private var weatherManager = WeatherManager()           //[Walter] WeatherManger 인스턴스
    private let singleTon = UIApplication.shared.delegate as? AppDelegate       //[Walter] AppDelegate 인스턴스
    
    //[Walter] AppDelegate 싱글톤 객체 인스턴스
//    var singleInApp:AppDelegate?
    
    //[Walter] api 여러개 호출시..
    let apiCallQueue = DispatchQueue(label: "apiCall", qos: .background, attributes: .concurrent)
    let apiCallGroup = DispatchGroup()
    
    override func viewDidLoad() {
//        self.singleInApp = UIApplication.shared.delegate as? AppDelegate
        self.locationManager.delegate = self        //[Walter] 현재 위치 델리게이트
        self.weatherManager.delegate = self         //[Walter] 날씨 정보 델리게이트
    }
    
    func moveToMain() {
        guard let data = UIApplication.shared.delegate as? AppDelegate else { return }
        guard data.weather != nil else { return }
        guard data.air != nil else { return }
        
        performSegue(withIdentifier: Keys.FromSplash.toMainId, sender: self)
    }
}

// MARK: - CLLocation Delegate 현재 위치 날씨 가져올 때 사용
extension SplashVC: CLLocationManagerDelegate {
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
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            locationManager.startUpdatingHeading()        //계속 위치 정보를 받아올 때 사용.
//            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
//            print("위치 정보 : 경도\(lat), 위도\(lon)")
            
            //네트워크 체크
            //현재 위치 정보를 기반으로 날씨, 미세먼지 검색
            weatherManager.getCurrWeatherWithCoordinate(lat: lat, lon: lon)                     //날씨
            weatherManager.getAirPolutiontionWithCoordinate(lat: lat, lon: lon)         //미세먼지
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("현재 위치 가져오기 오류 : \(error)")
    }
}

// MARK: - WeatherManager Delegate
extension SplashVC: WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel) {
        print("받아온 날씨 \(weather)")
        DispatchQueue.main.async {
            if let singleTon = self.singleTon {
                singleTon.weather = weather
            }
            self.moveToMain()
        }
    }
    
    func didUpdateAirViews(air: AirPolutionModel) {
        print("받아온 미세먼지 \(air)")
        DispatchQueue.main.async {
            if let singleTon = self.singleTon {
                singleTon.air = air
            }
            self.moveToMain()
        }
    }
    
    func didFailWithError(error: Error) {
        print("오류 \(error)")
    }
}
