//
//  MainScreenTableSectionExtention.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

// Mark:
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourInfo", for: indexPath) as! HourInfoCell
        cell.temperatureLabel.text = "aaaaa"
        //cell.backgroundColor = .green
        return cell
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
        //collectionView.register(HourInfoCell.self, forCellWithReuseIdentifier: "hourInfo")
        
        return collectionView
    }
    
}
