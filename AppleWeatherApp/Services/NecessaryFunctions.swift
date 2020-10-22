//
//  NecessaryFunctions.swift
//  AppleWeatherApp
//
//  Created by Тимофей Лукашевич on 20.10.20.
//

import Foundation

func getDayName(index: Int) -> String {
    let daysArray = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    if index < daysArray.count {
       return daysArray[index]
    }
    return ""
}

func getTodayDayName() -> String {
    let weekdayInd = Calendar.current.component(.weekday, from: Date())
    return getDayName(index: weekdayInd)
}
