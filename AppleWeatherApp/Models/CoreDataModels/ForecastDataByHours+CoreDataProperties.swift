//
//  ForecastDataByHours+CoreDataProperties.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 24.10.20.
//
//

import Foundation
import CoreData


extension ForecastDataByHours {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastDataByHours> {
        return NSFetchRequest<ForecastDataByHours>(entityName: "ForecastDataByHours")
    }

    @NSManaged public var time: String?
    @NSManaged public var image: String?
    @NSManaged public var temp: Double
    @NSManaged public var id: Int64
    
    

}

extension ForecastDataByHours : Identifiable {

}
