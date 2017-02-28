//
//  FacebookButton.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/22/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class LoginScreenButton: UIButton {

    let shadowColor : CGFloat = 155.0 / 255.0
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(displayP3Red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
