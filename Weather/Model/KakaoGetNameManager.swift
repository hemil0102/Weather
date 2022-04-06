//
//  KakaoManager.swift
//  Weather
//
//  Created by Walter J on 2022/04/06.
//

import Foundation
import Alamofire
import CoreLocation

protocol KakaoGetNameMangerDelegate {
    func getPriceName(si: String, gu: String, dong: String)
    func getFailWithError(error: Error)
}

struct KakaoGetNameManager {
    let url = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
    let header: HTTPHeaders = [
        "Content-Type": "application/json;charset=UTF-8",
        "Authorization": "KakaoAK \(Keys.KakaoApi.restApi)"
    ]
    
    var getNameDelegate: KakaoGetNameMangerDelegate?
    
    //[Walter] 좌표를 주소로 변경
    func convertCoordinateToPlace(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let param: Parameters = ["x": lon, "y": lat]
        performRequest(param: param)
    }
    
    //[Walter] 카카오에 데이터 요청
    func performRequest(param: Parameters) {
        AF.request(url, parameters: param, headers: header).responseDecodable(of: KakaoToGetPlaceName.self) { response in
            //                print("received kakao data : \(value)")
            switch response.result {
            case .success(let value):
                let _ = value.meta.total_count                                      //결과값 갯수
                let _ = value.documents[0].address.region_1depth_name               //도
                let address_si_gu = value.documents[0].address.region_2depth_name   //시, 구
                let address_dong = value.documents[0].address.region_3depth_name    //동
                
                let sigu = address_si_gu.split(separator: " ")
                let si = String(sigu[0])
                let gu = String(sigu[1])
                
//                print("시 구 동: \(si), \(gu), \(address_dong)")
                getNameDelegate?.getPriceName(si: si, gu: gu, dong: address_dong)
                
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                getNameDelegate?.getFailWithError(error: error)
            }
        }
    }
}
