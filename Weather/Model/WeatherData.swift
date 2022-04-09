//
//  WeatherInfo.swift
//  Weather
//
//  Created by Walter J on 2022/04/05.
//

import Foundation

struct WeatherData: Codable {
    let current: Current            // 지역명
    let daily: [Daily]
}

struct Current: Codable {
    let temp: Double
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Daily: Codable {
    let temp: Temp
    let humidity: Int
    let wind_speed: Double
    let weather: [Weather]
    let clouds: Int
    let uvi: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
