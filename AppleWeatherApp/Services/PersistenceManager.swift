//
//  PersistenceService.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 24.10.20.
//

import UIKit
import CoreData

final class PersistenceManager {
    
    private init(){}
    static let share = PersistenceManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather_Core_Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var context = persistentContainer.viewContext
        
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Fetch function
    
    func fetch<T:NSManagedObject>(_ objectType: T.Type, sort: NSSortDescriptor?) -> [T] {
        
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if sort != nil {
            fetchRequest.sortDescriptors = [sort!]
        }
        
        do {
            let objects = try context.fetch(fetchRequest) as? [T]
            return objects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    // MARK: - Core Data Delete function
    
    func clearCoreData() {
        
        let entityNames = ["ForecastDataByHours", "MainForecastData", "WeekForecastData"]
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                fetchRequest.returnsObjectsAsFaults = false
                do {
                    let results = try context.fetch(fetchRequest)
                    for object in results {
                        guard let objectData = object as? NSManagedObject else {continue}
                        context.delete(objectData)
                    }
                } catch let error {
                    print("Detele all data in \(entityName) error :", error)
                }
        }
        
        deleteImagesCopys()
    }
    
    func deleteImagesCopys() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        do {
            let results = try context.fetch(fetchRequest)
            var imagesNames = [String?]()
            for object in results {
                guard let imageData = object as? Images else {continue}
                if imagesNames.contains(imageData.titile) {
                    context.delete(imageData)
                } else {
                    imagesNames.append(imageData.titile)
                }
            }
        } catch  {
            print("Detele image error :", error)
        }
    }
    
}
