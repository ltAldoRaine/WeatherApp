//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import CoreLocation
import Alamofire
import AlamofireObjectMapper

class WeatherApi {

    weak var delegate: WeatherApiDelegate?

    func today(lat: CLLocationDegrees?, lon: CLLocationDegrees?) {
        guard let lat = lat, let lon = lon else {
            return
        }
        let url = "\(Network.weatherApirUrl)/weather?lat=\(lat)&lon=\(lon)&appid=\(Network.weatherApiKey)"
        delegate?.notifyBeforeGettingToday()
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseObject { (response: DataResponse<TodayResponse>) in
                self.delegate?.notifyGettingTodayFinish()
                switch response.result {
                case .success:
                    let todayResponse = response.value
                    self.delegate?.notifyGettingTodaySuccess(response: todayResponse)
                case .failure(let error):
                    self.delegate?.notifyGettingTodayFailure("An error occurred, please try again later")
                    print(error)
                }
        }
    }

    func forecast(lat: CLLocationDegrees?, lon: CLLocationDegrees?) {
        guard let lat = lat, let lon = lon else {
            return
        }
        let url = "\(Network.weatherApirUrl)/forecast?lat=\(lat)&lon=\(lon)&appid=\(Network.weatherApiKey)"
        delegate?.notifyBeforeGettingForecast()
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseObject { (response: DataResponse<ForecastResponse>) in
                self.delegate?.notifyGettingForecastFinish()
                switch response.result {
                case .success:
                    let forecastResponse = response.value
                    self.delegate?.notifyGettingForecastSuccess(response: forecastResponse)
                case .failure(let error):
                    self.delegate?.notifyGettingForecastFailure("An error occurred, please try again later")
                    print(error)
                }
        }
    }

}
