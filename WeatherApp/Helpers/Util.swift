//
//  Util.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class Util {

    static func alert(UIViewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            UIViewController.present(alertController, animated: true)
        }
    }

    static func actionSheet(UIViewController: UIViewController, title: String, message: String?, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.sourceView = UIViewController.view
                popoverPresentationController.sourceRect = CGRect(x: UIViewController.view.bounds.midX, y: UIViewController.view.bounds.midY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = []
            }
            actions.forEach { alertController.addAction($0) }
            UIViewController.present(alertController, animated: true)
        }
    }

    static func locationActionSheet(UIViewController: UIViewController) {
        let noAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url)
        }
        Util.actionSheet(UIViewController: UIViewController, title: "WeatherApp Requires \"When In Use\" Location Access", message: "Please, go to settings and turn on \"When In Use\" location access for WeatherApp", actions: [noAction, settingsAction])
    }

}

