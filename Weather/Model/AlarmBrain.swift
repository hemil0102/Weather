//
//  Alarm.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import Foundation

// 알람 기능 구현부
struct AlarmBrain {
    var myAlarm: AlarmModel? //객체화
    
//[Harry] 현재 날짜와 시간을 가져오는 함수
    func getCurrentDT() -> String {
        // [date 객체 사용해 현재 날짜 및 시간 24시간 형태 출력 실시]
        let nowDate = Date() // 현재의 Date 날짜 및 시간
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        
        dateFormatter.dateFormat = "yyyy.MM.dd kk:mm:ss E요일" // Date 포맷 타입 지정
        let date_string = dateFormatter.string(from: nowDate) // 포맷된 형식 문자열로 반환

        print("")
        print("===============================")
        print("날짜 :: ", date_string)
        print("===============================")
        print("")
            
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
        
        print("")
        print("===============================")
        print("요일 :: ", currentDay)
        print("요일Index :: ", currentDayIndex)
        print("===============================")
        print("")
        
        return currentDayIndex
    }
}
