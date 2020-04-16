//
//  TitleView.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/16/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class TitleView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)
        contentView.fixInView(self)
    }

}
