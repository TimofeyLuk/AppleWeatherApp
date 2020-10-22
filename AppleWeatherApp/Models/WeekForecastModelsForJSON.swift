//
//  WeekForecastModels.swift
//  WeatherApp
//
//  Created by Тимофей Лукашевич on 20.09.20.
//  Copyright © 2020 Тимофей Лукашевич. All rights reserved.
//

import Foundation

struct WeekForecast: Decodable {
    var list: [WeekForecastElement]?
    var city: City?
    
}

struct WeekForecastElement: Decodable {
    var main: Main?
    var weather: [Weather]?
    var dt_txt: String?
}

struct City: Decodable {
    var name: String?
}


