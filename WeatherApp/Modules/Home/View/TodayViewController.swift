//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController {

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
        titleView.titleLabel.text = "Today"
        weatherApi.delegate = self
        weatherApi.today(lat: locationManager.location?.coordinate.latitude, lon: locationManager.location?.coordinate.longitude)
    }

}

extension TodayViewController: WeatherApiDelegate {

    func notifyBeforeGettingToday() {

    }

    func notifyGettingTodayFinish() {

    }

    func notifyGettingTodaySuccess(response: TodayResponse?) {

    }

    func notifyGettingTodayFailure(_ error: String) {

    }

}
