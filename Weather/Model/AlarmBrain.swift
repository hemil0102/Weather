//
//  Alarm.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import Foundation

// 알람 기능 구현부
struct AlarmBrain {
    var myAlarm: AlarmModel? //알람 정보 데이터 객체
    var myPikcerView = AlarmPickerRange() //피커뷰 시간 범위 객체

//[Harry] 피커뷰 초기 시간 설정 값 지정을 위한 종민님 코드를 베낀 함수
    func getArrayIndexInt(arr: [Int], value: Int) -> Int? {
        return arr.firstIndex(of: value)
    }

//[Harry] 피커뷰 초기 시간 설정 값 지정을 위한 종민님 코드를 베낀 함수
    func getArrayIndexString(arr: [String], value: String) -> Int? {
        return arr.firstIndex(of: value)
    }
    
//[Harry] 현재 날짜와 시간을 가져오는 함수
    func getCurrentDT() -> String {
        // [date 객체 사용해 현재 날짜 및 시간 24시간 형태 출력 실시]
        let nowDate = Date() // 현재의 Date 날짜 및 시간
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        
        dateFormatter.dateFormat = "yyyy.MM.dd kk:mm:ss E요일" // Date 포맷 타입 지정
        let date_string = dateFormatter.string(from: nowDate) // 포맷된 형식 문자열로 반환
        
        return date_string
    }
    
//[Harry] 현재 요일을 구분하는 Index를 반환해주는 함수
    func getWeekDayIndex() -> Int {
        
        let currentDay = getCurrentDT()[getCurrentDT().index(getCurrentDT().endIndex,offsetBy: -3)]
        var currentDayIndex: Int
        
        if currentDay == "월" {
            currentDayIndex = 0
        } else if currentDay == "화" {
            currentDayIndex = 1
        } else if currentDay == "수" {
            currentDayIndex = 2
        } else if currentDay == "목" {
            currentDayIndex = 3
        } else if currentDay == "금" {
            currentDayIndex = 4
        } else if currentDay == "토" {
            currentDayIndex = 5
        } else {
            currentDayIndex = 6
        }
        
        return currentDayIndex
    }
//[Harry] 현재 시간만 얻어오는 함수
    func getCurrentHour24() -> String {
        let currentHourStart = getCurrentDT().index(getCurrentDT().startIndex, offsetBy: 11)
        let currentHourEnd = getCurrentDT().index(getCurrentDT().startIndex, offsetBy: 12)
        let currentHour24 = String(getCurrentDT()[currentHourStart...currentHourEnd])
        
        return String(currentHour24)
    }
//[Harry] 현재 시간을 12 단위로 변환하는 함수
    func getCurrentHour12() -> String {
        let currentHour24 = getCurrentHour24()
        var currentHour12 = 0
        
        if Int(currentHour24)! > 12 {
            currentHour12 = Int(currentHour24)! - 12
        } else {
            currentHour12 = Int(currentHour24)!
        }
        
        return String(currentHour12)
    }
//[Harry] Meridiem을 반환하는 함수
    func getCurrentMeridiem() -> String {
        let currentHour24 = getCurrentHour24()
        var currentMeridiem = ""
        
        if Int(currentHour24)! > 12 {
            currentMeridiem = "PM"
        } else {
            currentMeridiem = "AM"
        }
        
        return currentMeridiem
    }
    
//[Harry] 현재 분을 얻어오는 함수
    func getCurrentMinute() -> String {
        let currentMinuteStart = getCurrentDT().index(getCurrentDT().startIndex, offsetBy: 14)
        let currentMinuteEnd = getCurrentDT().index(getCurrentDT().startIndex, offsetBy: 15)
        let currentMinute = String(getCurrentDT()[currentMinuteStart...currentMinuteEnd])
        
        return String(currentMinute)
    }
    


}
