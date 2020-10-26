//
//  WeekForecastData+CoreDataProperties.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 24.10.20.
//
//

import Foundation
import CoreData


extension WeekForecastData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekForecastData> {
        return NSFetchRequest<WeekForecastData>(entityName: "WeekForecastData")
    }

    @NSManaged public var image: String?
    @NSManaged public var temp_max: Double
    @NSManaged public var temp_min: Double
    @NSManaged public var id: Int64

    func setData(_ weekForecast: Forecast?, dayIndex: Int) {
        if weekForecast == nil {return}
        if weekForecast?.data  != nil {
            let key = (Array((weekForecast!.data!.keys)).map({ String($0)}))[dayIndex]
            let dayData = weekForecast?.data?[key]
            self.id = Int64(dayIndex)
            self.temp_max = dayData??.first?.main?.temp_max ?? 0.0
            self.temp_min = dayData??.first?.main?.temp_min ?? 0.0
            self.image = dayData??.first?.weather?.first?.icon
        }
    }
}

extension WeekForecastData : Identifiable {

}
