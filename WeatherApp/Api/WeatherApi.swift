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

    func today(lat: CLLocationDegrees?, lon: CLLocationDegrees?, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) {
        guard let lat = lat, let lon = lon else {
            return
        }
        let latRounded = Double(lat).rounded(toPlaces: 3)
        let lonRounded = Double(lon).rounded(toPlaces: 3)
        let url = "\(Network.weatherApirUrl)/weather?lat=\(latRounded)&lon=\(lonRounded)&units=metric&appid=\(Network.weatherApiKey)"
        delegate?.notifyBeforeGettingToday()
        do {
            var urlRequest = try Alamofire.URLRequest(url: url, method: .get)
            urlRequest.cachePolicy = cachePolicy
            Alamofire.request(urlRequest)
                .validate()
                .responseObject { (response: DataResponse<TodayResponse>) in
                    self.delegate?.notifyGettingTodayFinish()
                    switch response.result {
                    case .success:
                        let todayResponse = response.value
                        // MARK - Renew cache if difference between api date and current date is greater than 10 minute
                        if let dt = todayResponse?.dt,
                            let timezone = todayResponse?.timezone,
                            let now = Date().GMTTimeDate {
                            let from = Date(timeIntervalSince1970: dt + timezone)
                            if let minute = Calendar.current.dateComponents([.minute], from: from, to: now).minute, minute > 10 {
                                self.today(lat: lat, lon: lon)
                                return
                            }
                        }
                        self.delegate?.notifyGettingTodaySuccess(response: todayResponse)
                    case .failure(let error):
                        self.delegate?.notifyGettingTodayFailure("An error occurred, please try again later")
                        print(error)
                    }
            }
        } catch let error {
            print(error)
        }
    }

    func forecast(lat: CLLocationDegrees?, lon: CLLocationDegrees?, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) {
        guard let lat = lat, let lon = lon else {
            return
        }
        let latRounded = Double(lat).rounded(toPlaces: 3)
        let lonRounded = Double(lon).rounded(toPlaces: 3)
        let url = "\(Network.weatherApirUrl)/forecast?lat=\(latRounded)&lon=\(lonRounded)&units=metric&appid=\(Network.weatherApiKey)"
        delegate?.notifyBeforeGettingForecast()
        do {
            var urlRequest = try Alamofire.URLRequest(url: url, method: .get)
            urlRequest.cachePolicy = cachePolicy
            Alamofire.request(urlRequest)
                .validate()
                .responseObject { (response: DataResponse<ForecastResponse>) in
                    self.delegate?.notifyGettingForecastFinish()
                    switch response.result {
                    case .success:
                        let forecastResponse = response.value
                        // MARK - Renew cache if difference between api date and current date is greater or equal than 6 hour
                        if let from = forecastResponse?.list?.first?.dtTxt?.toDate(format: "yyyy-MM-dd HH:mm:ss"),
                            let now = Date().GMTTimeDate {
                            if let minute = Calendar.current.dateComponents([.minute], from: from, to: now).minute, minute >= 360 {
                                self.forecast(lat: lat, lon: lon)
                                return
                            }
                        }
                        self.delegate?.notifyGettingForecastSuccess(response: forecastResponse)
                    case .failure(let error):
                        self.delegate?.notifyGettingForecastFailure("An error occurred, please try again later")
                        print(error)
                    }
            }
        } catch let error {
            print(error)
        }
    }

}
