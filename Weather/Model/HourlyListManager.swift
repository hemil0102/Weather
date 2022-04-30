//
//  HourlyListManager.swift
//  Weather
//
//  Created by Walter J on 2022/04/30.
//

import Foundation

struct HourlyListManager {
    let hourlyList:[HourlyData]
    
    init(model: [HourlyData]) {
        self.hourlyList = model
    }
    
    func getCount() -> Int {
        return hourlyList.count
    }
    
    func getHoulyWeatherAt(at: Int) -> HourlyData {
        return hourlyList[at]
    }
}
