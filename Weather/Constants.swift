//
//  Constants.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import Foundation

struct Keys {
    struct GoogleTestAD {
        static let testBannerADKey = "ca-app-pub-3940256099942544/2934735716"
        static let testNativeADKey = "ca-app-pub-3940256099942544/3986624511"
    }
    
    struct ApiId {
        static let weatherAppId = "d03b61bd0fafa57cf46bd374eb796830"
        static let airPolutionId = "d0aedaa971b852d7c7d77cb006728cf6" //[jongmin] 미세먼지용 키
    }
    
    // [Harry]
    static let alarmCellNibName = "AlarmCell"
    static let alarmCellIdentifier = "AlarmCellIdentifier"
}

struct ViewIdentifier {
    static let weatherDetailCell = "WeatherDetailCell" //뷰 이름
    static let weatherDetailCellIdentifier = "WeatherDetailCell" //테이블 뷰 아이덴티파이어
    static let editAlarmSegueIdentifier = "EditAlarm"
}
