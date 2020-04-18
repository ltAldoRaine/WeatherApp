//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    override func prepareForReuse() {
        iconImageView.image = nil
        hourLabel.text = nil
        summaryLabel.text = nil
        tempLabel.text = nil
        separatorView.isHidden = true
        contentView.borderWidth = 0
        contentView.borderColor = nil
    }

}

class ForecastViewController: UIViewController {

    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!

    private let weatherApi = WeatherApi()
    private let locationManager = CLLocationManager()

    private var authorizationStatusIsDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    private var currentLatitude: CLLocationDegrees? {
        return locationManager.location?.coordinate.latitude
    }
    private var currentLongitude: CLLocationDegrees? {
        return locationManager.location?.coordinate.longitude
    }
    private var forecastData = [(date: Date, list: [Forecast])]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let nib = UINib(nibName: "ForecastTableViewSectionHeaderView", bundle: nil)
        forecastTableView.rowHeight = view.frame.height / 6.0
        forecastTableView.sectionHeaderHeight = view.frame.height / 14.0
        forecastTableView.register(nib, forHeaderFooterViewReuseIdentifier: "ForecastTableViewSectionHeaderView")
        weatherApi.delegate = self
        lightRefresh()
    }

    @IBAction func swipeGestureHandler(_ sender: UISwipeGestureRecognizer) {
        forceRefresh()
    }

    private func resetDataAndViews() {
        titleView.titleLabel.text = "..."
        forecastData.removeAll()
        forecastTableView.reloadData()
    }

    private func lightRefresh() {
        resetDataAndViews()
        weatherApi.forecast(lat: currentLatitude, lon: currentLongitude, cachePolicy: .returnCacheDataElseLoad)
//        weatherApi.forecast(lat: 41.72784423828125, lon: 44.80842660755109, cachePolicy: .returnCacheDataElseLoad)
    }

    private func forceRefresh() {
        resetDataAndViews()
        weatherApi.forecast(lat: currentLatitude, lon: currentLongitude)
//        weatherApi.forecast(lat: 41.72784423828125, lon: 44.80842660755109)
    }

}

extension ForecastViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        lightRefresh()
        if authorizationStatusIsDenied {
            Util.locationActionSheet(UIViewController: self)
        }
    }

}

extension ForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        forecastData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData[section].list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
        let section = forecastData[indexPath.section]
        let forecast = section.list[indexPath.row]
        let firstWeather = forecast.weather?.first
        let firstWeatherMain = forecast.weatherMain
        if let icon = Network.weather(icon: firstWeather?.icon), let url = URL(string: icon) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: url) { result in
                switch result {
                case .failure:
                    cell.iconImageView.image = Image.noImageAvailable
                default:
                    return
                }
            }
        }
        cell.hourLabel.text = forecast.dtTxt?.toDate(format: "yyyy-MM-dd HH:mm:ss").toString(format: "HH:mm")
        cell.summaryLabel.text = firstWeather?.main
        if let temp = firstWeatherMain?.temp {
            cell.tempLabel.text = "\(Int(round(temp)))°"
        }
        if indexPath.row != section.list.count - 1 && !(indexPath.section == 0 && indexPath.row == 0) {
            cell.separatorView.isHidden = false
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.contentView.borderWidth = 1.0
            cell.contentView.borderColor = .blue
        }
        return cell
    }

}

extension ForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ForecastTableViewSectionHeaderView") as! ForecastTableViewSectionHeaderView
        let day = forecastData[section].date.toString(format: "EEEE")
        if day == Date().toString(format: "EEEE") {
            sectionHeaderView.dayLabel.text = "TODAY"
        } else {
            sectionHeaderView.dayLabel.text = day.uppercased()
        }
        return sectionHeaderView
    }

}

extension ForecastViewController: WeatherApiDelegate {

    func notifyBeforeGettingForecast() {
        activityIndicatorView.startAnimating()
    }

    func notifyGettingForecastFinish() {
        activityIndicatorView.stopAnimating()
    }

    func notifyGettingForecastSuccess(response: ForecastResponse?) {
        guard let response = response else {
            return
        }
        titleView.titleLabel.text = response.city?.name
        guard let list = response.list else {
            return
        }
        list.forEach { item in
            guard let dtTxt = item.dtTxt else {
                return
            }
            let date = dtTxt.toDate(format: "yyyy-MM-dd HH:mm:ss")
            let day = date.toString(format: "dd")
            var exists = false
            forecastData.forEach {
                if $0.date.toString(format: "dd") == day {
                    exists = true
                    return
                }
            }
            if exists {
                forecastData.enumerated().forEach {
                    if $0.element.date.toString(format: "dd") == day {
                        forecastData[$0.offset].list.append(item)
                        return
                    }
                }
            } else {
                forecastData.append((date: date, list: [item]))
            }
        }
        forecastTableView.reloadData()
    }

    func notifyGettingForecastFailure(_ error: String) {
        Util.alert(UIViewController: self, title: "Error", message: error)
    }

}
