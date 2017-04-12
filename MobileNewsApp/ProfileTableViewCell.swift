//
//  JoinStoryTableViewCell.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    //@IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var imgMyTurn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
