//
//  AlarmCell2.swift
//  Weather
//
//  Created by YEHROEI HO on 2022/04/13.
//

import UIKit

class SearchAreaCell: UITableViewCell {
    
    @IBOutlet var weatherIconImageView: UIImageView!
    @IBOutlet var showCurrLocationLabel: UILabel!
    @IBOutlet var areaNameLabel: UILabel!
    @IBOutlet var currTempLabel: UILabel!
    @IBOutlet var currCloudLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
