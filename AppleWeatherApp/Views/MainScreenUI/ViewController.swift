//
//  ViewController.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 20.10.20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTable: UITableView!{
        didSet {
            weatherTable.backgroundColor = .clear
            weatherTable.delegate = self
            weatherTable.dataSource = self
            weatherTable.allowsSelection = false
        }
    }
    
    var topViewIsShifted = false
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        weatherTable.register(TenDaysCell.self, forCellReuseIdentifier: "TenDaysCell")
        
        let descriptionNib = UINib(nibName: "DescriptionViewCell", bundle: nil)
        weatherTable.register(descriptionNib, forCellReuseIdentifier: "DescriptionViewCell")
        
        let additionalInfoNib = UINib(nibName: "AdditionalInfoCell", bundle: nil)
        weatherTable.register(additionalInfoNib, forCellReuseIdentifier: "AdditionalInfoCell")
    }
    
    func shiftTopView() {
        let shift = !topViewIsShifted ? -70.0 : 0.0
        topViewIsShifted = !topViewIsShifted
        UIView.animate(withDuration: 0.5)
        {
            self.locationLabel.transform = CGAffineTransform(translationX: 0, y: CGFloat(shift))
            self.weatherDescription.transform = CGAffineTransform(translationX: 0, y: CGFloat(shift))
            self.weatherTable.transform = CGAffineTransform(translationX: 0, y: CGFloat(shift))
        }
    }
    
    // MARK: Table functions
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == weatherTable {
            if scrollView.contentOffset.y == 0 {
                shiftTopView()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == weatherTable {
            if scrollView.contentOffset.y == 0 {
                shiftTopView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            return CGFloat(120)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            return CGFloat(94)
        }
        return UITableView.automaticDimension
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        let parametrs = ["Sunrise", "Sunrise", "Chance of Rain", "Humidity", "Wind", "Feels Like", "Precipitation", "Pressure", "Visibility"]
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "temperatureCell", for: indexPath) as! TemperatureCell
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "TenDaysCell", for: indexPath) as! TenDaysCell
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionViewCell", for: indexPath) as! DescriptionViewCell
            case 2...11:
                cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell", for: indexPath) as! AdditionalInfoCell
                if let cellCopy = cell as?  AdditionalInfoCell {
                    cellCopy.parameterLabel.text = parametrs[indexPath.row - 2]
                }
            default:
                break
            }
        default:
            break
        }
        
        cell.backgroundColor = .clear
        return cell
    }
}

