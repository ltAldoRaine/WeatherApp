//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

extension String {

    func toDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        return date
    }

}
