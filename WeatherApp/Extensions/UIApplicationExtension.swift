//
//  UIApplicationExtension.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/22/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

extension UIApplication {

    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
    static var reachability: Reachability {
        return appDelegate.reachability
    }

}
