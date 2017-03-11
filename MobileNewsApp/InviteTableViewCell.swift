//
//  InviteTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import M13Checkbox

class InviteTableViewCell: UITableViewCell {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkboxView: UIView!
    var checkbox : M13Checkbox! = nil
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: checkboxView.bounds.width, height: checkboxView.bounds.height))
        
        
        
//        let view = UIView(frame: CGRect(x: cell.checkboxView.frame.minX, y: cell.checkboxView.frame.minY, width: cell.checkboxView.bounds.width, height: cell.checkboxView.bounds.height))
//        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(InviteViewController.selectUser))
//        view.addGestureRecognizer(gesture)
        checkboxView.isUserInteractionEnabled = false
        checkboxView.addSubview(checkbox)
//        cell.addSubview(view)
        
    }
    
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        checkbox.toggleCheckState(true)
        // Configure the view for the selected state
    }

}
