//
//  WeatherApiDelegate.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

protocol WeatherApiDelegate: class {

    func notifyBeforeGettingToday()

    func notifyGettingTodayFinish()

    func notifyGettingTodaySuccess(response: TodayResponse?)

    func notifyGettingTodayFailure(_ error: String)

    func notifyBeforeGettingForecast()

    func notifyGettingForecastFinish()

    func notifyGettingForecastSuccess(response: ForecastResponse?)

    func notifyGettingForecastFailure(_ error: String)

}

extension WeatherApiDelegate {

    func notifyBeforeGettingToday() { }

    func notifyGettingTodayFinish() { }

    func notifyGettingTodaySuccess(response: TodayResponse?) { }

    func notifyGettingTodayFailure(_ error: String) { }

    func notifyBeforeGettingForecast() { }

    func notifyGettingForecastFinish() { }

    func notifyGettingForecastSuccess(response: ForecastResponse?) { }

    func notifyGettingForecastFailure(_ error: String) { }

}
