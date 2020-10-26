//
//  DayWeatherModel.swift
//  WeatherApp
//
//  Created by Тимофей Лукашевич on 18.09.20.
//  Copyright © 2020 Тимофей Лукашевич. All rights reserved.
//

import Foundation
import CoreData

struct CurrentWeatherData: Decodable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    mutating func setData(_ forecastData: MainForecastData?) {
        if let data = forecastData {
            name = data.name
            weather = [Weather()]
            weather?[0].description = data.weatherDescription
            main = Main(temp: data.temp,
                        feels_like: data.feels_like,
                        temp_min: data.minTemp,
                        temp_max: data.maxTemp,
                        pressure: Int(data.pressure),
                        humidity: Int(data.humidity))
           
            wind = Wind(speed: data.windSpeed, deg: nil)
            clouds = Clouds(all: Int(data.clouds))
            sys = Sys(type: nil, id: nil, country: nil,
                      sunrise: Int(data.sunrise),
                      sunset: Int(data.sunset))
            visibility = Int(data.visibility)
        }
    }
}

struct Coord: Decodable {
    var lon: Int?
    var lan: Int?
}

struct Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}


struct Main: Decodable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Int?
    var humidity: Int?
}


struct Wind: Decodable {
    var speed: Double?
    var deg: Int?
}

struct Clouds: Decodable {
    var all: Int?
}

struct Sys: Decodable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}


