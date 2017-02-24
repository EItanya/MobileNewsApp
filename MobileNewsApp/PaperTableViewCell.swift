//
//  PaperTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class PaperTableViewCell: UITableViewCell {
    
    let shadowColor : CGFloat = 155.0 / 255.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 25.0
        layer.shadowColor = UIColor(displayP3Red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
