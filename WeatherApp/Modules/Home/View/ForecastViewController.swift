//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {

    @IBOutlet weak var titleView: TitleView!

    private let weatherApi = WeatherApi()
    private let locationManager = CLLocationManager()

    private var authorizationStatusIsDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if authorizationStatusIsDenied {
            Util.locationActionSheet(UIViewController: self)
        }
        weatherApi.delegate = self
        weatherApi.forecast(lat: locationManager.location?.coordinate.latitude, lon: locationManager.location?.coordinate.longitude)
    }

}

extension ForecastViewController: WeatherApiDelegate {

    func notifyBeforeGettingForecast() {

    }

    func notifyGettingForecastFinish() {

    }

    func notifyGettingForecastSuccess(response: ForecastResponse?) {
        titleView.titleLabel.text = response?.city?.name
    }

    func notifyGettingForecastFailure(_ error: String) {

    }

}
