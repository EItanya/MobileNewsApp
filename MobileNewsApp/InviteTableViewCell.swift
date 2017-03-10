//
//  InviteTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
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
