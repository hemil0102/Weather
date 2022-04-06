//
//  Kakao.swift
//  Weather
//
//  Created by Walter J on 2022/04/06.
//

import Foundation

// MARK: - 좌표를 주소로 변환
struct KakaoToGetPlaceName: Codable {
    let meta: Meta
    let documents: [Documents]
}

struct Documents: Codable {
    let address: Address                //지번 주소 상세 정보
}

struct Meta: Codable {
    let total_count: Int                //변환된 지번 주소 및 도로명 주소 의 개수, 0 또는 1
}

struct Address: Codable {
    let region_1depth_name: String      //지역 1Depth, 시도 단위 : 경기
    let region_2depth_name: String      //지역 2Depth, 구 단위 : 안산시
    let region_3depth_name: String      //지역 3Depth, 면 단위 : 죽전면
}

// MARK: - 지역명을 좌표로 변환
struct KakaoToGetCoordinate: Codable {
    
}
