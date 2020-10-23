//
//  HourInfoCell.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

class HourInfoCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var probabilityOfPrecipitationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
   // @IBOutlet weak var viewsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        viewsStack.backgroundColor = .clear
//        viewsStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        viewsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        viewsStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        viewsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Initialization code
    }

}
