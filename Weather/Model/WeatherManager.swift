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

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let oneCallApiUrl = "https://api.openweathermap.org/data/2.5/onecall"
    var parseCSV = ParsingCSV()
    
    /*
     [Walter]
     1. Prameters Update [✌️]
     2. POST로 날씨 요청 []
     3. 응답 받기 [✌️]
     5. delegate 패턴으로 호출 VC에 결과 (WeatherModel/Error) 전달 [✌️]
     */
    
    //[Walter] 현재 날씨 가져오기
    mutating func getWeatherWithName(name: String) {
        parseCSV.delegate = self
    }
    
    //[Walter] 현재 좌표(lat, lon)을 기반으로 날씨 가져오기
    func getWeatherWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let param: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": Keys.ApiId.weatherAppId,
            "exclude": "hourly, minutely",
            "units": "metric"
        ]
    
        performRequest(param: param)
    }
    
    //[Walter] 날씨 요청
    func performRequest(param: Parameters) {
        AF.request(oneCallApiUrl, parameters: param)
            .responseDecodable(of: WeatherData.self) { response in
//                print("received weater data : \(response)")
                switch response.result {
                    //성공
                case .success(let value):
//                    print("날씨 정보 : \(value)")
                    //현재 날씨
                    let cTemp = value.current.temp
                    let cSunrise = value.current.sunrise
                    let cSunset = value.current.sunset
                    let cHumidity = value.current.humidity
                    let cClouds = value.current.clouds
                    let cWind_speed = value.current.wind_speed
                    let cConditionID = value.current.weather[0].id
                    let cDescription = value.current.weather[0].description
                    
                    let current = CurrWeather(temp: cTemp, sunrise: cSunrise, sunset: cSunset, humidity: cHumidity, clouds: cClouds, wind_speed: cWind_speed, conditionID: cConditionID, description: cDescription)
                    
                    //7일간의 일일 날씨 예측
                    var dailyData:[DailyData] = []
                    for daily in value.daily {
                        dailyData.append(DailyData(day: daily.temp.day, min: daily.temp.min, max: daily.temp.max, night: daily.temp.night, eve: daily.temp.eve, morn: daily.temp.morn, humidity: daily.humidity, wind_speed: daily.wind_speed, conditionID: daily.weather[0].id, description: daily.weather[0].description, clouds: daily.clouds, uvi: daily.uvi))
                    }
                    
                    let weatherModel = WeatherModel(currWeather: current, daily: dailyData)
                    self.delegate?.didUpdateWeatherViews(weather: weatherModel)
                    //실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
}

//[Walter] CSV 파일을 파싱해서 가져온 좌표값을 getWeatherWithCoordinate(lat:lon:) 함수로 전달
extension WeatherManager: ParsingCsvDelegate {
    func getCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.getWeatherWithCoordinate(lat: lat, lon: lon)
    }
}
