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
        let view = UIView(frame: CGRect(x: checkboxView.frame.minX, y: checkboxView.frame.minY, width: checkboxView.bounds.width, height: checkboxView.bounds.height))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(InviteTableViewCell.checkBox))
        view.addGestureRecognizer(gesture)
        
        checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: checkboxView.bounds.width, height: checkboxView.bounds.height))
        checkboxView.addSubview(checkbox)
        checkboxView.isUserInteractionEnabled = false
        self.addSubview(view)
        
        
    }
    
    func checkBox() {
        checkbox.toggleCheckState(true)
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class IgnoreTouchView : UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self { return nil }
        return hitView
    }

}
