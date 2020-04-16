//
//  GradientView.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _1Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _2Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _3Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _4Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _5Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var _6Color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    private func updateView() {
        guard let layer = self.layer as? CAGradientLayer else {
            return
        }
        layer.colors = [_1Color, _2Color, _3Color, _4Color, _5Color, _6Color].map { $0.cgColor }
        if isHorizontal {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1.0)
        }
    }

}
