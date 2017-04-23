//
//  UserTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/9/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class UserTableViewCell: MGSwipeTableCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet var blockLabel: UILabel!
   
    var user: User?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
