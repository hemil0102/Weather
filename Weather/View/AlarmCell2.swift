//
//  AlarmCell2.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/13.
//

import UIKit

class AlarmCell2: UITableViewCell {

    //xib 파일 내에서 사용되는 객체들
    @IBOutlet weak var alarmCellSwitch: UISwitch! // Section2, 스위치
    @IBOutlet weak var alarmCellToDo: UILabel! // Section2, 할일
    @IBOutlet weak var alarmCellTime: UILabel! // Section2, 시간
    @IBOutlet weak var alarmCellMeridiem: UILabel! // Section2, AMPM
    @IBOutlet weak var alarmCellDayType: UILabel! // Section2, 요일 종류
    @IBOutlet weak var alarmCellWeekday: UILabel! // Section2, 선택된 요일
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
