//
//  Network.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class Network {

    static let weatherApirUrl = "https://api.openweathermap.org/data/2.5"
    static let weatherApiKey = "e7da42b9a3a035dc2a2ade8878633604"

    static func weather(icon: String?) -> String? {
        guard let icon = icon else {
            return nil
        }
        return "https://openweathermap.org/img/wn/\(icon)@\(Int(UIScreen.main.scale))x.png"
    }

}
