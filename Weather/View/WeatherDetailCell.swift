//
//  WeatherDetailTableViewCell.swift
//  Weather
//
//  Created by JONGMIN Youn on 2022/04/04.
//

import UIKit

//[종민] Weather탭 테이블뷰 셀 정의
class WeatherDetailCell: UITableViewCell {

    @IBOutlet weak var weatherDetailImageIcon: UIImageView!
    @IBOutlet weak var weatherDetailData1: UILabel!
    @IBOutlet weak var weatherDetailData2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configDetailCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//[jongmin] 관련 세팅 함수
extension WeatherDetailCell {
    
    func configDetailCell() {
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor(named: "MovelLilac")
        
    }
    
    
}

//아이콘/
