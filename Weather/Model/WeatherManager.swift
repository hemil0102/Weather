//
//  WeatherManager.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation
import Alamofire
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager: KakaoGetNameMangerDelegate {
    var delegate: WeatherManagerDelegate?
    let currWeatherApiUrl = "https://api.openweathermap.org/data/2.5/weather"
    let oneCallApiUrl = "https://api.openweathermap.org/data/2.5/onecall"
    var param: Parameters = [
        "lat": "",
        "lon": "",
        "appid": Keys.ApiId.weatherAppId,
        "exclude": "daily",
        "units": "metric"
    ]
    
    var kakaoManager = KakaoGetNameManager()
    
    mutating func getCurrWeather(cityName: String) {
        /*
         [Walter]
         1. 도시명 오류 체크 []
         2. 도시명 한글 -> 영어로 변경 []
         3. Prameters Update [✌️]
         4. POST로 날씨 요청 [...]
         5. 응답 받기 [✌️]
         6. 전달받은 도시명 영문 -> 한글로 변경 []
         7. delegate 패턴으로 호출 VC에 결과 (WeatherModel/Error) 전달 [✌️]
         */
    
        performRequest()        //[Walter] 날씨 요청
    }
    
    //[Walter] 현재 날씨 가져오기
    func getCurrWeatherData() {
        
    }
    
    //[Walter] 현재 좌표(lat, lon)을 기반으로 지도에서 지역명 찾기
    mutating func getCityNameWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        /*
         [Walter] 카카오 API에서 좌표를 찍어 지역명 가져오기
         1. 카카오 로컬 API 호출 [✌️]
         2. 지역명 가져오기 [✌️]
         */
        kakaoManager.getNameDelegate = self
        kakaoManager.convertCoordinateToPlace(lat: lat, lon: lon)
    }
    
    func getPriceName(si: String, gu: String, dong: String) {
        
        print("si \(si), gu \(gu), dong \(dong)")
    }
    
    func getFailWithError(error: Error) {
        print("좌표로 지역명 가져오기 오류 : \(error)")
    }
    
    //[Walter] 사용자가 입력한 한글 지역명을 기반으로 지도에서 좌표(lat, lon) 가져오기
    func getCoordinateWithCityName(cityName: String) {
        /*
         [Walter]
         1. 카카오 API에서 지역명으로 검색, 좌표 가져오기
         */
    }
    
    //[Walter] 날씨 요청
    func performRequest() {
        //[Walter] Post 로 전달이 안된다... 일단 Get으로..
//        let urlStr = "\(currWeatherApiUrl)?q=suwon&appid=\(Keys.ApiId.weatherAppId)&units=metric"
        
        AF.request(oneCallApiUrl, parameters: param)
            .responseDecodable(of: Weather.self) { response in
//                print("received weater data : \(response)")
                switch response.result {
                    //성공
                case .success(let value):
//                    print("날씨 정보 : \(value)")
                    
                    let name = value.name
                    let currTemp = value.main.temp
                    let minTemp = value.main.temp_min
                    let maxTemp = value.main.temp_max
                    let humidity = value.main.humidity
                    let conditionId = value.weather[0].id
                    let description = value.weather[0].description
                    
                    let weatherModel = WeatherModel(name: name, temp: currTemp, temp_min: minTemp, temp_max: maxTemp, humidity: humidity, conditionId: conditionId, description: description)
                    self.delegate?.didUpdateWeatherViews(weather: weatherModel)
                    //실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
}
