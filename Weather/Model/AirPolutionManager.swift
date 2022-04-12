//
//  AirPolutionManager.swift
//  Weather
//
//  Created by JONGMIN Youn on 2022/04/12.
//

import Foundation
import Alamofire
import CoreLocation

protocol AirPolutionManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct AirPolutionManager {
    var delegate: AirPolutionManagerDelegate?
    let airPolutionApiUrl = "https://openweathermap.org/api/air-pollution"
    
    init() {
        getAirPolutiontionWithCoordinate(lat: 35.61, lon: 129.3798) //[jongmin] 울산 위/경도 임시 데이터
        
    }
    
    //[Walter] 현재 좌표(lat, lon)을 기반으로 날씨 가져오기
    func getAirPolutiontionWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        print("마지막으로 받은... 위/경도 \(lat), \(lon)")
        
        let param: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": Keys.ApiId.airPolutionId
        ]
    
        performRequest(param: param)
    }
    
    func performRequest(param: Parameters) {
        AF.request(airPolutionApiUrl, parameters: param)
            .responseDecodable(of: AirPolution.self) { response in
                print("received polution data : \(response)")
                switch response.result {
                    //성공
                case .success(let value):
//                    print("날씨 정보 : \(value)")
                    //현재 날씨
                    let cPM2_5 = value.list.components.pm2_5
                    let cPM10 = value.list.components.pm10
                    
                    print("pm2.5:\(cPM2_5), pm10: \(cPM10)")
                    //self.delegate?.didUpdateWeatherViews(weather: weatherModel)
                    
                //실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
}


