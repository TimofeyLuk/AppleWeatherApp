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

func getTime(input: Int?, format: String) -> String {
    guard let timestamp = input else { return "undefined" }
    let epocTime = TimeInterval(timestamp)
    let date = Date(timeIntervalSince1970: epocTime)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

