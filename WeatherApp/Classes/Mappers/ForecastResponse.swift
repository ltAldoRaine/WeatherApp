//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import ObjectMapper

class ForecastResponse: Mappable {

    var list: [TodayResponse]?
    var city: City?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        city <- map["city"]
        list <- map["list"]
    }

}

class City: Mappable {

    var id: Int?
    var name: String?
    var country: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        country <- map["country"]
    }

}
