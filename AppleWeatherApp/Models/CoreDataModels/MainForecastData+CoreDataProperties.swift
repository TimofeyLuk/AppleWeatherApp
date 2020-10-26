//
//  MainForecastData+CoreDataProperties.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 24.10.20.
//
//

import Foundation
import CoreData


extension MainForecastData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainForecastData> {
        return NSFetchRequest<MainForecastData>(entityName: "MainForecastData")
    }

    @NSManaged public var name: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var temp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var windSpeed: Double
    @NSManaged public var feels_like: Double
    @NSManaged public var clouds: Int64
    @NSManaged public var pressure: Int64
    @NSManaged public var visibility: Int64
    
    
    func setData(_ currentForecast: CurrentWeatherData?) {
        self.name = currentForecast?.name
        self.weatherDescription = currentForecast?.weather?.first?.description
        self.feels_like = currentForecast?.main?.feels_like ?? 0.0
        self.maxTemp = currentForecast?.main?.temp_max ?? 0.0
        self.minTemp = currentForecast?.main?.temp_min ?? 0.0
        self.temp = currentForecast?.main?.temp_min ?? 0.0
        self.windSpeed = currentForecast?.main?.temp ?? 0.0
        self.clouds = Int64(currentForecast?.clouds?.all ?? 0)
        self.humidity = Int64(currentForecast?.main?.humidity ?? 0)
        self.pressure = Int64(currentForecast?.main?.pressure ?? 0)
        self.sunrise = Int64(currentForecast?.sys?.sunrise ?? 0)
        self.sunset = Int64(currentForecast?.sys?.sunset ?? 0)
        self.visibility = Int64(currentForecast?.visibility ?? 0)
    }

}

extension MainForecastData : Identifiable {

}
