//
//  DoubleExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

extension Double {

    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
