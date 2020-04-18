//
//  ForecastTableViewSectionHeaderView.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/17/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ForecastTableViewSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var dayLabel: UILabel!

    override func prepareForReuse() {
        dayLabel.text = nil
    }

}
