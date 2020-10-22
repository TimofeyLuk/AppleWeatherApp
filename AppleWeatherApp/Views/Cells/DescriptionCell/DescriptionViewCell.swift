//
//  DescriptionViewCell.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

class DescriptionViewCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var descriptionText = " "
    var temp = 0
    var maxTemp = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rootView.backgroundColor = .clear
        descriptionLabel.text = "Today: \(descriptionText). It's \(temp)°; the high will be \(maxTemp)°."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
