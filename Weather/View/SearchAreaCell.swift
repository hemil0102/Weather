//
//  SearchAreaCell.swift
//  Weather
//
//  Created by Walter J on 2022/04/18.
//

import UIKit

class SearchAreaCell: UITableViewCell {

    @IBOutlet weak var showCurrLocationIcon: UIImageView!
    @IBOutlet weak var showCurrLocationLabel: UILabel!
    @IBOutlet weak var searchedAreaNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
