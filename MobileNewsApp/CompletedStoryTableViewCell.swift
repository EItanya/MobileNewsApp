//
//  CompletedStoryTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/7/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class CompletedStoryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var entryAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
