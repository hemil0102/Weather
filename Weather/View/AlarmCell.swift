//
//  AlarmCell.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    /* ⭐️ AlarmCell IBOutlet 정의 ⭐️ */
    
    //xib 파일 내에서 사용되는 객체들
    @IBOutlet weak var alarmCellSwitch: UISwitch! // Section1, 스위치
    @IBOutlet weak var alarmCellLocation: UILabel! // Section1, 지역
    @IBOutlet weak var alarmCellToDo: UILabel! // Section1, 할일
    @IBOutlet weak var alarmCellTime: UILabel! // Section1, 시간
    @IBOutlet weak var alarmCellMeridiem: UILabel! // Section1, AMPM
    @IBOutlet weak var alarmCellDayType: UILabel! // Section1, 요일 종류
    @IBOutlet weak var alarmCellWeekday: UILabel! // Section1, 선택된 요일

    
    /* ⭐️ AlarmCell 함수 정의 ⭐️ */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        alarmCellSwitch.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        // [Harry] 스위치 고유 크기를 Scale에 기반하여 축소
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
