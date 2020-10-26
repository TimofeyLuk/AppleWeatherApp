//
//  Images+CoreDataProperties.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 24.10.20.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var titile: String?
    @NSManaged public var image: Data?

}

extension Images : Identifiable {

}
