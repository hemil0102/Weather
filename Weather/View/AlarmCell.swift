//
//  AlarmCell.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/08.
//

import UIKit

class AlarmCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        alarmSwitch.transform = CGAffineTransform(scaleX: 0.75, y:0.75)
        // [Harry] 스위치 고유 크기를 Scale에 기반하여 축소
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
}
