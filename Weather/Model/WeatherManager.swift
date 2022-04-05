//
//  WeatherManager.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeatherViews(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherApiUrl = "https://api.openweathermap.org/data/2.5/weather"
    var param: Parameters = ["q": "", "appid": Keys.ApiId.weatherAppId, "units": "metric"]
    
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
        
        self.param["q"] = cityName
        performRequest()        //[Walter] 날씨 요청
    }
    
    //[Walter] 날씨 요청
    func performRequest() {
        
        //[Walter] Post 로 전달이 안된다... 일단 Get으로..
        let urlStr = "\(weatherApiUrl)?q=suwon&appid=\(Keys.ApiId.weatherAppId)&units=metric"
        
        AF.request(urlStr, method: .get)
            .responseDecodable(of: WeatherInfo.self) { response in
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
