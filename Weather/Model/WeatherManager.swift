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
    func didUpdateAirViews(air: AirPolutionModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let oneCallApiUrl = "https://api.openweathermap.org/data/2.5/onecall"
    let historyCallApiUrl = "https://api.openweathermap.org/data/2.5/onecall/timemachine"
    let airPolutionApiUrl = "https://api.openweathermap.org/data/2.5/air_pollution"
    var parseCSV = ParsingCSV()
    let patchGroup = DispatchGroup()

    /*
     [Walter]
     1. Prameters Update [✌️]
     2. POST로 날씨 요청 [ ]
     3. 응답 받기 [✌️]
     5. delegate 패턴으로 호출 VC에 결과 (WeatherModel/Error) 전달 [✌️]
     6. 2번씩 호출하는 문제 잡기 [ ]
     */
    
    init() {
        parseCSV.getDataCsvAt()         //csv 파싱
    }
    
    //[Walter] 지역명을 CSV에서 찾아 좌표 가져오기
    mutating func getWeatherWithName(name: String) {
//        parseCSV.delegate = self
        parseCSV.searchUserKeyword(place: name)
    }
}

// MARK: - [Walter] 좌표 기반 현재 날씨 가져오기
extension WeatherManager {
    func getCurrWeatherWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let param: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": Keys.ApiId.weatherAppId,
            "exclude": "hourly, minutely",
            "units": "metric"
        ]
//        print("요청 URL 및 파라미터 : \(oneCallApiUrl), \(param)")
        performRequestToGetCurrWeather(param: param)            //현재 날씨 데이터 가져오기
    }
    
    //[Walter] 현재 날씨 요청
    func performRequestToGetCurrWeather(param: Parameters) {
        var weather: WeatherModel?
        
        patchGroup.enter()
        AF.request(oneCallApiUrl, parameters: param)
            .responseDecodable(of: WeatherData.self) { response in
//                print("응답 : \(response)")
                switch response.result {
                    
                    //성공
                case .success(let value):
                    print("현재 날씨 정보 in AF : \(value)")
                    //현재 날씨
                    let cTemp = value.current.temp
                    let cSunrise = value.current.sunrise
                    let cSunset = value.current.sunset
                    let cHumidity = value.current.humidity
                    let cClouds = value.current.clouds
                    let cWind_speed = value.current.wind_speed
                    let cConditionID = value.current.weather[0].id
                    let cDescription = value.current.weather[0].description
                    
                    let current = CurrWeather(
                        temp: cTemp,
                        sunrise: cSunrise,
                        sunset: cSunset,
                        humidity: cHumidity,
                        clouds: cClouds,
                        wind_speed: cWind_speed,
                        conditionID: cConditionID,
                        description: cDescription
                    )
                    
                    //7일간의 일일 날씨 예측
                    var dailyData:[DailyData] = []
                    for daily in value.daily {
                        dailyData.append(
                            DailyData(
                                day: daily.temp.day,
                                min: daily.temp.min,
                                max: daily.temp.max,
                                night: daily.temp.night,
                                eve: daily.temp.eve,
                                morn: daily.temp.morn,
                                humidity: daily.humidity,
                                wind_speed: daily.wind_speed,
                                conditionID: daily.weather[0].id,
                                description: daily.weather[0].description,
                                clouds: daily.clouds,
                                uvi: daily.uvi
                            )
                        )
                    }
                
                    weather = WeatherModel(si: "수원시", dong: "구운동", currWeather: current, daily: dailyData)
                    
                    //실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
                    self.delegate?.didFailWithError(error: error)
                }
                
                patchGroup.leave()
            }
        
        patchGroup.notify(queue: .global(qos: .background)) {
            print("현재 날씨 가져오기 작업 완료")
            if let weather = weather {
                delegate?.didUpdateWeatherViews(weather: weather)
            }
        }
    }
}

// MARK: - //[Walter] 좌표 기반 미세먼지 정보 가져오기
extension WeatherManager {
    func getAirPolutiontionWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let param: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": Keys.ApiId.airPolutionId
        ]
        
        performRequestToGetAirPolution(param: param)
    }
    
    //[Walter] 미세먼지 요청
    func performRequestToGetAirPolution(param: Parameters) {
        var air: AirPolutionModel?
        
        patchGroup.enter()
        AF.request(airPolutionApiUrl, parameters: param)
            .responseDecodable(of: AirPolution.self) { response in
                print("미세먼지 정보 in AF : \(response)")
                switch response.result {
                    //성공
                case .success(let value):
                    //현재 날씨
                    let cPM2_5 = value.list[0].components.pm2_5
                    let cPM10 = value.list[0].components.pm10
                    
                    air = AirPolutionModel(cPM2_5: cPM2_5, cPM10: cPM10)
                    
                    //실패
                case .failure(let error):
                    print("error: \(String(describing: error.errorDescription))")
                    self.delegate?.didFailWithError(error: error)
                }
                
                patchGroup.leave()
            }
        
        patchGroup.notify(queue: .global(qos: .background)) {
            print("미세먼지 작업 완료")
            if let air = air {
                delegate?.didUpdateAirViews(air: air)
            }
        }
    }
}

// MARK: - //[Walter] 지난 날짜 데이터 가져오기
extension WeatherManager {
    func getHisWeatherWithCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        //문자열 날짜포맷을 dt포맷으로 변환
        let dateStr = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMdHHmm"
        guard let date:Date = dateFormatter.date(from: dateStr) else { return }
        
        let param: Parameters = [
            "lat": lat,
            "lon": lon,
            "dt": date,
            "appid": Keys.ApiId.weatherAppId
        ]
        
        performRequestToGetHistoryWeather(param: param)         //지난 날짜 데이터 가져오기
    }
    
    
    //[Walter] 지난 시간 날씨 요청
    func performRequestToGetHistoryWeather(param: Parameters) {
//        AF.request(oneCallApiUrl, parameters: param)
//            .responseDecodable(of: WeatherData.self) { response in
//
//            }
    }
}

// MARK: - [Walter] CSV 파일을 파싱해서 가져온 좌표값을 getWeatherWithCoordinate(lat:lon:) 함수로 전달
//extension WeatherManager: ParsingCsvDelegate {
//    mutating func getCoordinate(lat: CLLocationDegrees, lon: CLLocationDegrees) {
//        self.getCurrWeatherWithCoordinate(lat: lat, lon: lon)
//    }
//}
