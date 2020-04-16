//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreLocation

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

extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherInfoCollectionViewCell", for: indexPath) as! WeatherInfoCollectionViewCell
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

    }

    func notifyGettingTodayFinish() {

    }

    func notifyGettingTodaySuccess(response: TodayResponse?) {
        if let icon = Network.weather(icon: response?.weather?.first?.icon), let url = URL(string: icon) {
            iconImageView.kf.setImage(with: url)
        }
    }

    func notifyGettingTodayFailure(_ error: String) {

    }

}
