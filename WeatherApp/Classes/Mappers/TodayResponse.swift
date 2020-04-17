//
//  TodayResponse.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import ObjectMapper

class TodayResponse: Mappable {

    var weatherMain: WeatherMain?
    var weather: [Weather]?
    var wind: Wind?
    var rain: Rain?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        weatherMain <- map["main"]
        weather <- map["weather"]
        wind <- map["wind"]
        rain <- map["rain"]
    }

}

class WeatherMain: Mappable {

    var temp: Float?
    var pressure: Int?
    var humidity: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        temp <- map["temp"]
        pressure <- map["pressure"]
        humidity <- map["humidity"]
    }

}


class Weather: Mappable {

    var main: String?
    var icon: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        main <- map["main"]
        icon <- map["icon"]
    }

}

class Wind: Mappable {

    var speed: Float?
    var deg: Float?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        speed <- map["speed"]
        deg <- map["deg"]
    }

}

class Rain: Mappable {

    var _1h: Float?
    var _3h: Float?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        _1h <- map["1h"]
        _3h <- map["3h"]
    }

}


