//
//  JoinStoryTableViewCell.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class HomeStoryTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var peopleAheadLabel: UILabel!
    @IBOutlet var turnCountLabel: UILabel!
    @IBOutlet var spotsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
