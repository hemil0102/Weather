//
//  WeatherDetailTableViewCell.swift
//  Weather
//
//  Created by JONGMIN Youn on 2022/04/04.
//

import UIKit

//[jongmin] Weather탭 테이블뷰 셀 정의
class WeatherDetailCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var DetailCellBackgroundView: UIView!
    @IBOutlet weak var weatherDetailImageIcon: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
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
        DetailCellBackgroundView.layer.cornerRadius = 15
    }
    
    
    //[jongmin] 테이블 뷰 간격 주기
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
    }
    
    
}

//아이콘/
