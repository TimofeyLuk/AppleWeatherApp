//
//  AdditionalInfoCell.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

class AdditionalInfoCell: UITableViewCell {

    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rootView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
