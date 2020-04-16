//
//  TodayResponse.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import ObjectMapper

class TodayResponse: Mappable {

    var weather: [Weather]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        weather <- map["weather"]
    }

}

class Weather: Mappable {

    var icon: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        icon <- map["icon"]
    }

}


