//
//  KakaoGetCoordiManager.swift
//  Weather
//
//  Created by Walter J on 2022/04/06.
//

import Foundation
import Alamofire

struct KakaoGetCoordiManager {
    let url = "https://dapi.kakao.com/v2/local/search/address.json"
    let header: HTTPHeaders = [
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization": "KakaoAK \(Keys.KakaoApi.restApi)"
    ]
    
    //[Walter] 지역명을 좌표로 변경
    func convertPlaceNameToCoordinate(placeName: String) {
        
    }
    
}
