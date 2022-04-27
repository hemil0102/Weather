//
//  ConvertDateFormat.swift
//  Weather
//
//  Created by Walter J on 2022/04/27.
//

import Foundation

class ConvertDateFormat {
    func dtToString() {
        //UTC포맷의 Date를 날짜 형태의 String으로 변경
        // Date를 날짜로
        let dateFormatter2 = DateFormatter()
        let date = Date(timeIntervalSinceReferenceDate: 1649925797)

        dateFormatter2.locale = Locale(identifier: "ko_KR")
        dateFormatter2.setLocalizedDateFormatFromTemplate("yyyy-MM-dd hh:mm") // set template after setting locale
        print("데이터 포맷을 날짜로 변경 : \(dateFormatter2.string(from: date))")
    }
    
    func stringToDt() {
        //날짜 형태의 String을 UTC포맷의 Date형태로 변경
        // 날짜를 Date로
        let dateStr = "2022-04-14 05:52"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        if let date:Date = dateFormatter.date(from: dateStr) {
            print("날짜를 데이터 포맷으로 변경 : \(date)")
        } else {
            print("날짜를 데이터 포맷으로 변경하기 실패")
        }
    }
}
