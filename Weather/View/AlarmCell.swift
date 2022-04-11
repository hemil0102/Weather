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
    @IBOutlet weak var alarmCellSwitch: UISwitch!
    @IBOutlet weak var alarmCellLocation: UILabel!
    @IBOutlet weak var alarmCellToDo: UILabel!
    @IBOutlet weak var alarmCellTime: UILabel!
    @IBOutlet weak var alarmCellMeridiem: UILabel!
    @IBOutlet weak var alarmCellDayType: UILabel!
    
    //요일 레이블, 선택된 요일에 따라서 배경색을 달리 지정하기 위한
    @IBOutlet weak var alarmCellMonday: UILabel!
    @IBOutlet weak var alarmCellTuesday: UILabel!
    @IBOutlet weak var alarmCellWednesday: UILabel!
    @IBOutlet weak var alarmCellThursday: UILabel!
    @IBOutlet weak var alarmCellFriday: UILabel!
    @IBOutlet weak var alarmCellSaturday: UILabel!
    @IBOutlet weak var alarmCellSunday: UILabel!
    
    
    
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
