//
//  DayTableViewCell.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxtemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rootView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
