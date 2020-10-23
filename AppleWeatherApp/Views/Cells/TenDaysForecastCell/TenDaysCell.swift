//
//  TenDaysCell.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 21.10.20.
//

import UIKit

class TenDaysCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 600
        table.backgroundColor = .clear
        table.separatorStyle = .none
        let nib = UINib(nibName: "DayTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "dayTableCell")
        return table
    }()
    
    weak var forecast: Forecast?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        table.dataSource = self
        table.delegate = self
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "dayTableCell", for: indexPath)
        
        if let cellCopy = cell as? DayTableViewCell{
            cellCopy.weekdayLabel.text = getDayName(index: indexPath.row + 2)
            if forecast?.data != nil {
                let key = (Array((forecast!.data!.keys)).map({ String($0)}))[indexPath.row]
                let dayData = forecast?.data?[key]
                
                cellCopy.maxtemp.text = "\(Int(dayData??.first?.main?.temp_max ?? 0))"
                cellCopy.minTemp.text = "\(Int(dayData??.first?.main?.temp_min ?? 0))"
                cellCopy.weatherImage.image = forecast?.images?[dayData??.first?.weather?.first?.icon ?? ""]
            }
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    

}
