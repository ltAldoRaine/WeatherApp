//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

extension Date {

    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }

}
