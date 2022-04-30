//
//  AlarmModel.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import Foundation

// [Harry] 알람 관련 변수를 지정
struct AlarmModel {
    
    var alarmTime: String? // [Harry] 알람 시간 설정
    var alarmMeridiem: String? // [Harry] 알람 오전/오후 표기
    var alarmWeekDay: [String]? // [Harry] 알람 요일
    var alarmIsEnable: Bool? // [Harry] 알람 스위치 ON/OFF
    var alarmToDo: String? // [Harry] 알람 할일
    var alarmIsRepeat: Bool? // [Harry] 알람이 반복성인지 아닌지 체크

}

// [Harry] 알람 헤더 지정
    let alarmSectionHeader = ["반복 요일 알람", "특정 요일 알람"]

// [Harry] 알람 설정 피커뷰 범위
struct AlarmPickerRange {
    var alarmPickerViewHours: [Int] = Array(0...12)
    var alarmPickerViewMinutes: [Int] = Array(0...59)
    var alarmPickerViewMeridiems: [String] = ["AM", "PM"]
}
