//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import ObjectMapper

class ForecastResponse: Mappable {

    var city: City?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        city <- map["city"]
    }

}

class City: Mappable {

    var name: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
    }

}
