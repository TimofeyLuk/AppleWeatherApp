//
//  WeekForecastViewModel.swift
//  WeatherApp
//
//  Created by Тимофей Лукашевич on 20.09.20.
//  Copyright © 2020 Тимофей Лукашевич. All rights reserved.
//

import UIKit

class Forecast {
    
    var city: City?
    var data: [String:[ForecastElement]?]?
    var images: [String: UIImage]?
    
    init(forecast: WeekForecast) {
        city = forecast.city
        data = [:]
        if let dataList = forecast.list {
             for el in dataList {
                if let dataTimeStr = el.dt_txt{
                    
                    let dateRange = dataTimeStr.startIndex...dataTimeStr.firstIndex(of: " ")!
                    
                    let timeRange = dataTimeStr.index(after: dataTimeStr.firstIndex(of: " ")!)...dataTimeStr.index(dataTimeStr.firstIndex(of: " ")!, offsetBy: 5)
                    
                    let dataString = String(dataTimeStr[dateRange])
                    let timeString = String(dataTimeStr[timeRange])
                    
                    let forecastElement = ForecastElement(main: el.main,
                                                          weather: el.weather,
                                                          time: timeString)
                    if self.data![dataString] != nil {
                        self.data![dataString]!?.append(forecastElement)
                    } else {
                        self.data![dataString] = [forecastElement]
                    }
                    
                }
            }
        }
    }
}

class ForecastElement {
    var main: Main?
    var weather: [Weather]?
    var time: String?
    
    init(main: Main?, weather: [Weather]?, time: String?) {
        self.main = main
        self.weather = weather
        self.time = time
    }
}
