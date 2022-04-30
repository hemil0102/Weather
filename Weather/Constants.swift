//
//  Constants.swift
//  Weather
//
//  Created by Walter J on 2022/04/04.
//

import Foundation

struct Keys {
    //[Walter] 광고 관련 테스트에만 쓰이는 키
    struct GoogleTestAD {
        static let testBannerADKey = "ca-app-pub-3940256099942544/2934735716"
        static let testNativeADKey = "ca-app-pub-3940256099942544/3986624511"
    }
    
    //[Walter] api key
    struct ApiId {
        static let weatherAppId = "d03b61bd0fafa57cf46bd374eb796830"
        static let airPolutionId = "d0aedaa971b852d7c7d77cb006728cf6" //[jongmin] 미세먼지용 키
    }
    
    // [Harry]
    static let alarmCellOneNibName = "AlarmCell"
    static let alarmCellOneIdentifier = "AlarmCellOneIdentifier"
    static let alarmCellTwoNibName = "AlarmCell2"
    static let alarmCellTwoIdentifier = "AlarmCellTwoIdentifier"
    
    //[Walter]
    struct FromSplash {
        static let toMainId = "SplashToMain"
    }
    
    //[Walter]
    struct HourlyCell {
        static let cellId = "HourlyWeatherListCell"
    }
    
    //[Walter] 지역검색 모달 관련 Identifier
    struct SearchArea {
        static let segueId = "HomeToSearchAreaModel"
        static let storyboardId = "searchAreaModal"
        static let cellName = "SearchAreaCell"
        static let cellId = "SearchAreaCell"
    }
}

struct ViewIdentifier {
    static let weatherDetailCell = "WeatherDetailCell" //뷰 이름
    static let weatherDetailCellIdentifier = "WeatherDetailCell" //테이블 뷰 아이덴티파이어
    static let editAlarmSegueIdentifier = "EditAlarm"
}
