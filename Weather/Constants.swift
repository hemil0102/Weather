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
    }
    
    struct KakaoApi {
        static let native = "3c7e3e7cb071c026c94b67cc55dc0cfc"
        static let restApi = "05fb60e76e2e702a16a8a8fa46351c54"
        static let admin = "f416692664fa7e3422552123fd6fe5cd"
    }
    
    struct ApiId2 {
        static let weatherAppId2 = "d0aedaa971b852d7c7d77cb006728cf6" //[jongmin] 미세먼지 전용...
    }
}

struct ViewIdentifier {
    static let weatherDetailCell = "WeatherDetailCell" //뷰 이름
    static let weatherDetailCellIdentifier = "WeatherDetailCell" //테이블 뷰 아이덴티파이어
}
