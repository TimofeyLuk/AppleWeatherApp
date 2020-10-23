//
//  MainScreenTableSectionExtention.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

// Mark:
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return CGFloat(100.0)
        }
        return CGFloat(0.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let CellView = UIView(frame: CGRect(x: 0, y: 0, width: weatherTable.frame.width, height: 100))
            CellView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
            CellView.addSubview(createDayColectionView())
            return CellView
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let forecast = presenter?.weekForecast?.data {
            let keys = Array((forecast.keys)).map({ String($0)})
            let firstDayKey = keys[0]
            let secodDayKey = keys[1]
            
            let firstDayCount = forecast[firstDayKey]??.count ?? 0
            let secondDayCount = forecast[secodDayKey]??.count ?? 0
            
            return firstDayCount + secondDayCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourInfo", for: indexPath)
        if let cellCopy = cell as? HourInfoCell {
            if ((presenter?.weekForecast?.data) != nil) {
                let data = getDataArr()
                if let cellData = data?[indexPath.row] {
                    cellCopy.timeLabel.text = cellData.time ?? ""
                    if indexPath.row == 0 {
                        cellCopy.timeLabel.text = "Now"
                    }
                    cellCopy.weatherImage.image = presenter!.weekForecast?.images?[cellData.weather?.first?.icon ?? ""]
                    cellCopy.temperatureLabel.text = "\(cellData.main?.temp ?? 0)°"
                    cellCopy.probabilityOfPrecipitationLabel.text = ""
                }
            }
        }
        
        return cell
    }
    
    private func getDataArr() -> [ForecastElement]? {
        if let forecast = presenter.weekForecast?.data {
            let keys = Array((forecast.keys)).map({ String($0)})
            let firstDayKey = keys[0]
            let secodDayKey = keys[1]
            var res:[ForecastElement] = []
            
            let firstArr = forecast[firstDayKey]?! ?? Array<ForecastElement>()
            let secondArr = forecast[secodDayKey]?! ?? Array<ForecastElement>()
            
            res += firstArr
            res += secondArr
            
            return res
        }
        
        return nil
    }
    
    func createDayColectionView() -> UICollectionView {
        let flowLoayout = UICollectionViewFlowLayout()
        flowLoayout.itemSize = CGSize(width: 40, height: 90)
        flowLoayout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: weatherTable.frame.width, height: 100)
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLoayout)
        
        collectionView.layer.borderWidth = 0.8
        collectionView.layer.borderColor = UIColor.gray.cgColor
        
        collectionView.backgroundColor = .clear
        
        // add delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HourInfoCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "hourInfo")
        
        return collectionView
    }
    
}
