//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var titleView: TitleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.titleLabel.text = "London"
    }

}
