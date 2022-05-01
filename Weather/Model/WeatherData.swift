//
//  WeatherInfo.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation

// MARK: - [Walter] 오픈 웨더 데이터 구조체
struct WeatherData: Codable {
    let current: Current            // 지역명
    let hourly: [Hourly]
    let daily: [Daily]
}

// MARK: - [Walter] 현재 날씨
struct Current: Codable {
    let temp: Double
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
    let rain: Rain?
}

// MARK: - [Walter] 현재 날씨 - 시간별
struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let weather: [Weather]
    let pop: Double                 //강수 확률
}

//MARK: - [Walter] 주간 날씨
struct SevenDaysWeather: Codable {
    let daily: [Daily]
}

//MARK: - [Walter] 주간 날씨
struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let humidity: Int
    let wind_speed: Double
    let weather: [Weather]
    let clouds: Int
    let uvi: Double
}

//MARK: - [Walter] 날씨 상태
struct Weather: Codable {
    let id: Int
    let description: String
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

//MARK: - [Walter] 비
struct Rain: Codable {
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
    }
    let h1: Double
}

// MARK: - [Jongmin] 미세먼지 데이터 구조체
struct AirPolution: Codable {
    let list: [List]
}

struct List: Codable {
    let components: Components
}

struct Components: Codable {
    let pm2_5: Double
    let pm10: Double
}
