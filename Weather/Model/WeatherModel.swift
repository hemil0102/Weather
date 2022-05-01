//
//  WeatherModel.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation

struct WeatherModel {
    let si: String
    let dong: String
    let currWeather: CurrWeather
    let hourly: [HourlyData]
    let daily: [DailyData]
}

struct CurrWeather {
    let temp: Double            // 현재온도
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let conditionID: Int
    var tempStr: String {
        return String(format: "%.1f", temp)
    }
    var iconWithId: String {
        switch self.conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803, 804:
            return "smoke"
        default:
            return ""
        }
    }
    let description: String
    var descriptionKor: String {
        switch self.conditionID {
        case 200:
//            thunderstorm with light rain
//            return "가랑비를 동반한 번개"
            return "비를 동반한 번개"
        case 201:
//            thunderstorm with rain
//            return "비를 동반한 번개(폭풍우)"
            return "비를 동반한 번개"
        case 202:
//            thunderstorm with heavy rain
//            return "폭우를 동반한 번개"
            return "폭우를 동반한 번개"
        case 210:
//            light thunderstorm
//            return "가벼운 번개"
            return "천둥 번개"
        case 211:
//            thunderstorm
            return "천둥 번개"
        case 212:
//            heavy thunderstorm
//            return "강한 천둥 번개"
            return "천둥 번개"
        case 221:
//            ragged thunderstorm
//            return "너덜너덜한 번개"
            return "천둥 번개"
        case 230:
//            thunderstorm with light drizzle
//            return "가랑비를 동반한 약한 번개"
            return "비를 동반한 번개"
        case 231:
//            thunderstorm with drizzle
//            return "소나기를 동반한 번개"
            return "비를 동반한 번개"
        case 232:
//            thunderstorm with heavy drizzle
//            return "강한 소나기를 동반한 번개"
            return "비를 동반한 번개"
        case 300:
//            light intensity drizzle
//            return "약한 소나기"
            return "소나기"
        case 301:
//            drizzle
            return "소나기"
        case 302:
//            heavy intensity drizzle
//            return "강한 소나기"
            return "소나기"
        case 310:
//            light intensity drizzle rain
//            return "약한 가랑비"
            return "가랑비"
        case 311:
//            drizzle rain
            return "가랑비"
        case 312:
//            heavy intensity drizzle rain
//            return "강한 가랑비"
            return "가랑비"
        case 313:
//            shower rain and drizzle
            return "비"
        case 314:
//            heavy shower rain and drizzle
//            return "cloud.bolt"
            return "비"
        case 321:
//            shower drizzle
//            return "cloud.drizzle"
            return "비"
        case 500:
//            light rain
//            return "가벼운 비"
            return "비"
        case 501:
//            moderate rain
            return "비"
        case 502:
//            heavy intensity rain
            return "비"
        case 503:
//            very heavy rain
            return "비"
        case 504:
//            extreme rain
            return "비"
        case 511:
//            freezing rain
            return "비"
        case 520:
//            light intensity shower rain
            return "비"
        case 521:
//            shower rain
            return "비"
        case 522:
//            heavy intensity shower rain
            return "비"
        case 531:
//            ragged shower rain
            return "비"
        case 600:
//            light snow
            return "눈"
        case 601:
//            Snow
            return "눈"
        case 602:
//            Heavy snow
            return "폭설"
        case 611:
//            Sleet
            return "눈"
        case 612:
//            Light shower sleet
            return "눈"
        case 613:
//            Shower sleet
            return "눈"
        case 615:
//            Light rain and snow
            return "비를 동반한 눈"
        case 616:
//            Rain and snow
            return "비를 동반한 눈"
        case 620:
//            Light shower snow
            return "눈"
        case 621:
//            Shower snow
            return "눈"
        case 622:
//            Heavy shower snow
            return "눈"
        case 701:
//            mist
            return "안개"
        case 711:
//            Smoke
            return "안개"
        case 721:
//            Haze
            return "안개"
        case 731:
//            sand/ dust whirls
            return "먼지"
        case 741:
//            fog
            return "안개"
        case 751:
//            sand
            return "먼지"
        case 761:
//            dust
            return "먼지"
        case 762:
//            volcanic ash
            return "cloud.bolt"
        case 771:
//            squalls
            return "cloud.bolt"
        case 781:
//            tornado
            return "cloud.fog"
        case 800:
//            clear sky
            return "맑음"
        case 801:
//            few clouds: 11-25%
            return "약한 구름"
        case 802:
//            scattered clouds: 25-50%
            return "구름"
        case 803:
//            broken clouds: 51-84%
            return "흐림"
        case 804:
//            overcast clouds: 85-100%
            return "구름 많음"
        default:
            return ""
        }
    }
    
    let rain: Int
}

struct HourlyData {
    let dt: Int
    let temp: Double
    var tempStr: String {
        return String(format: "%.1f", temp)
    }
    let conditionID: Int
    var iconWithId: String {
        switch self.conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803, 804:
            return "smoke"
        default:
            return ""
        }
    }
    var conditionIcon: String {
        switch conditionID {
        case 0: return "비옴"
        default: return ""
        }
    }
    let pop: Double                 //강수 확률
}

struct DailyData {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
    let humidity: Int
    let wind_speed: Double
    let conditionID: Int
    let description: String
    let clouds: Int
    let uvi: Double
    
    var iconWithId: String {
        switch self.conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803, 804:
            return "smoke"
        default:
            return ""
        }
    }
}
