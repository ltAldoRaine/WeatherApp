//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class WeatherInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!

    override func prepareForReuse() {
        iconImageView.image = nil
        captionLabel.text = nil
    }

}

class TodayViewController: UIViewController {

    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var weatherDataCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!

    private let weatherApi = WeatherApi()
    private let locationManager = CLLocationManager()

    private var activityViewController: UIActivityViewController?
    private var authorizationStatusIsDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    private var currentLatitude: CLLocationDegrees? {
        return locationManager.location?.coordinate.latitude
    }
    private var currentLongitude: CLLocationDegrees? {
        return locationManager.location?.coordinate.longitude
    }
    private var weatherData = [[String: String]]()

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
        weatherApi.today(lat: currentLatitude, lon: currentLongitude, cachePolicy: .returnCacheDataElseLoad)
//        weatherApi.today(lat: 41.72784423828125, lon: 44.80842660755109, cachePolicy: .returnCacheDataElseLoad)
    }

    @IBAction func onShareButtonTapped() {
        guard let activityViewController = activityViewController else {
            return
        }
        present(activityViewController, animated: true)
    }

    @IBAction func swipeGestureHandler(_ sender: UISwipeGestureRecognizer) {
        resetDataAndViews()
        weatherApi.today(lat: currentLatitude, lon: currentLongitude)
//        weatherApi.today(lat: 41.72784423828125, lon: 44.80842660755109)
    }

    private func resetDataAndViews() {
        iconImageView.image = nil
        locationLabel.text = "..."
        summaryLabel.text = "..."
        weatherData.removeAll()
        weatherDataCollectionView.reloadData()
        activityViewController = nil
    }

    private func updateFRD(temp: Float?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let uuidString = UIDevice.current.identifierForVendor?.uuidString,
            let currentLatitude = currentLatitude,
            let currentLongitude = currentLongitude,
            let temp = temp else {
                return
        }
        appDelegate.ref.child("devices").child(uuidString).setValue([
            "cord": [
                "lat": currentLatitude,
                "lon": currentLongitude
            ],
            "temp": temp
            ])
    }

}

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherInfoCollectionViewCell", for: indexPath) as! WeatherInfoCollectionViewCell
        if let icon = weatherData[indexPath.item]["icon"] {
            cell.iconImageView.image = UIImage(named: icon)
        }
        cell.captionLabel.text = weatherData[indexPath.item]["value"]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let hSpace: CGFloat = (flowLayout?.minimumLineSpacing ?? 0.0) + (flowLayout?.sectionInset.top ?? 0.0) + (flowLayout?.sectionInset.bottom ?? 0.0)
        let width: CGFloat
        if indexPath.item == 3 || indexPath.item == 4 {
            width = collectionView.frame.width / 2.0
        } else {
            width = collectionView.frame.width / 3.0
        }
        let height = (collectionView.frame.height - hSpace) / 2.0
        return CGSize(width: width, height: height)
    }

}

extension TodayViewController: WeatherApiDelegate {

    func notifyBeforeGettingToday() {
        activityIndicatorView.startAnimating()
    }

    func notifyGettingTodayFinish() {
        activityIndicatorView.stopAnimating()
    }

    func notifyGettingTodaySuccess(response: TodayResponse?) {
        updateFRD(temp: response?.weatherMain?.temp)
        guard let response = response,
            let firstWeather = response.weather?.first,
            let firstWeatherMain = response.weatherMain else {
                return
        }
        if let icon = Network.weather(icon: firstWeather.icon), let url = URL(string: icon) {
            iconImageView.kf.indicatorType = .activity
            iconImageView.kf.setImage(with: url) { result in
                switch result {
                case .failure:
                    self.iconImageView.image = Image.noImageAvailable
                default:
                    return
                }
            }
        }
        if let name = response.name, let country = response.sys?.country {
            locationLabel.text = "\(name), \(country)"
        }
        if let temp = firstWeatherMain.temp, let main = firstWeather.main {
            summaryLabel.text = "\(Int(round(temp)))°C | \(main)"
        }
        if let humidity = firstWeatherMain.humidity {
            weatherData.append(["value": "\(humidity)%", "icon": "Humidity"])
        }
        let _3h = response.rain?._3h ?? 0
        weatherData.append(["value": "\(_3h) mm", "icon": "Precipitation"])
        if let pressure = firstWeatherMain.pressure {
            weatherData.append(["value": "\(pressure) hPa", "icon": "Presure"])
        }
        if let speed = response.wind?.speed {
            weatherData.append(["value": "\(speed) km/h", "icon": "Wind"])
        }
        if let deg = response.wind?.deg {
            weatherData.append(["value": deg.direction.description, "icon": "Compass"])
        }
        weatherDataCollectionView.reloadData()
        if let id = response.id, let url = URL(string: "\(Network.weatherWebUrl)/city/\(id)") {
            activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        }
    }

    func notifyGettingTodayFailure(_ error: String) {
        Util.alert(UIViewController: self, title: "Error", message: error)
    }

}
