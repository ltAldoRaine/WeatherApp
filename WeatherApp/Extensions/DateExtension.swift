//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

extension Date {

    var GMTTimeDate: Date? {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        dateComponents.calendar = Calendar.current
        if let timeZone = TimeZone(abbreviation: "GMT") {
            dateComponents.timeZone = timeZone
        }
        return Calendar.current.date(from: dateComponents)
    }

    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }

}
