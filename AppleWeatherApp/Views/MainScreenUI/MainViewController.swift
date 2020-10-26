//
//  ViewController.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 20.10.20.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol, UITableViewDelegate, UITableViewDataSource {
   
    var presenter: MainPresenterProtocole! 
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
        
        if presenter?.currentForecast != nil {
            locationLabel.text = presenter?.currentForecast?.name
            weatherDescription.text = presenter?.currentForecast?.weather?.first?.description
            weatherTable.reloadData()
        }
        if presenter?.weekForecast != nil {
            weatherTable.reloadData()
        }
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
            return CGFloat(130)
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
            if let cellCopy = cell as? TemperatureCell {
                if presenter?.currentForecast != nil {
                    cellCopy.weekDayLabel.text = getTodayDayName()
                    cellCopy.temperatureLabel.text = "\(Int(presenter.currentForecast?.main?.temp ?? 0))" + "°"
                    cellCopy.minTemp.text = "\(Int(presenter.currentForecast?.main?.temp_min ?? 0))"
                    cellCopy.maxTemp.text = "\(Int(presenter.currentForecast?.main?.temp_max ?? 0))"
                }
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "TenDaysCell", for: indexPath)
                if let cellCopy = cell as? TenDaysCell {
                    cellCopy.forecast = presenter?.weekForecast
                    cellCopy.table.reloadData()
                }
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionViewCell", for: indexPath)
                if let cellCopy = cell as? DescriptionViewCell {
                    if presenter?.currentForecast != nil {
                        let maxTemp = Int(presenter.currentForecast?.main?.temp_min ?? 0)
                        let temp = Int(presenter.currentForecast?.main?.temp ?? 0)
                        let descriptionText = presenter.currentForecast?.weather?.first?.description ?? ""
                        cellCopy.descriptionLabel.text = "Today: \(descriptionText). It's \(temp)°; the high will be \(maxTemp)°."
                    }
                }
            case 2...11:
                cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell", for: indexPath)
                if let cellCopy = cell as?  AdditionalInfoCell {
                    cellCopy.parameterLabel.text = parametrs[indexPath.row - 2]
                    if presenter?.currentForecast != nil {
                        switch (indexPath.row - 2)  {
                        case 0:
                            let time = (presenter.currentForecast?.sys?.sunrise) ?? 0
                            cellCopy.valueLabel.text = getTime(input: time, format: "HH:MM")
                        case 1:
                            let time = (presenter.currentForecast?.sys?.sunset) ?? 0
                            cellCopy.valueLabel.text = getTime(input: time, format: "HH:MM")
                        case 2:
                            let chance = (presenter.currentForecast?.clouds?.all) ?? 0
                            cellCopy.valueLabel.text = "\(chance)%"
                        case 3:
                            let humidity = (presenter.currentForecast?.main?.humidity) ?? 0
                            cellCopy.valueLabel.text = "\(humidity)%"
                        case 4:
                            let speed = (presenter.currentForecast?.wind?.speed) ?? 0
                            cellCopy.valueLabel.text = "\(speed)%"
                        case 5:
                            let feels_like = (presenter.currentForecast?.main?.feels_like) ?? 0
                            cellCopy.valueLabel.text = "\(feels_like)°"
                        case 6:
                            cellCopy.valueLabel.text = "-"
                        case 7:
                            let pressure = (presenter.currentForecast?.main?.pressure) ?? 0
                            cellCopy.valueLabel.text = "\(pressure) hPa"
                        case 8:
                            let visibility = (presenter.currentForecast?.visibility) ?? 0
                            cellCopy.valueLabel.text = "\(visibility) km"
                        default:
                            break
                        }
                    }
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

