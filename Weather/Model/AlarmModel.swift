//
//  AlarmModel.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import Foundation

// [Harry] 알람 관련 변수를 지정
struct AlarmModel {
    
    let alarmLocation: String // [Harry] 알람 지역 설정
    let alarmTime: Int // [Harry] 알람 시간 설정
    let alarmMeridiem: String // [Harry] 알람 오전/오후 표기
    let alarmWeekDay: String // [Harry] 알람 요일
    let alarmIsEnable: Bool // [Harry] 알람 스위치 ON/OFF
    let alarmToDo: String // [Harry] 알람 할일

}
