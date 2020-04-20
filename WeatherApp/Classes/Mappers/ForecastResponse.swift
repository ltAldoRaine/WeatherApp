//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import ObjectMapper

class ForecastResponse: Mappable {

    var list: [Forecast]?
    var city: City?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        city <- map["city"]
        list <- map["list"]
    }

}

class Forecast: Mappable {

    var weatherMain: WeatherMain?
    var weather: [Weather]?
    var wind: Wind?
    var rain: Rain?
    var dtTxt: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        weatherMain <- map["main"]
        weather <- map["weather"]
        wind <- map["wind"]
        rain <- map["rain"]
        dtTxt <- map["dt_txt"]
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
