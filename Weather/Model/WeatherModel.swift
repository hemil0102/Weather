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
    let daily: [DailyData]
}

struct CurrWeather {
    let temp: Double            // 현재온도
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let conditionID: Int
    let description: String
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
}
