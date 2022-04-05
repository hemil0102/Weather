//
//  WeatherInfo.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation

struct WeatherInfo: Codable {
    let name: String            // 지역명
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double            // 현재온도
    let temp_min: Double        // 당일 최저온도
    let temp_max: Double        // 당일 최대온도
    let humidity: Int           // 습도
}

struct Weather: Codable {
    let id: Int                 // 날씨 상태 ID
    let description: String      // 날씨 상태 설명
}
