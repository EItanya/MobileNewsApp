//
//  ManageInviteTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/12/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class ManageInviteTableViewCell: UITableViewCell {

    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var hiddenView: UIView! {
        didSet {
            hiddenView.isHidden = true
        }
    }
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var inviteId: String?
    var storyId: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptInviteBtn(_ sender: UIButton) {
        let query = PFQuery(className: "Story")
        query.getObjectInBackground(withId: storyId!, block: {(story: PFObject?, error: Error?) -> Void in
            if error != nil {
                print("Error getting story")
            }
            else {
                let story = Story.convertToStory(story: story!)
                story.addUser(completion: nil)
            }
        })
    }
    
    @IBAction func rejectInviteBtn(_ sender: UIButton) {
        let query = PFQuery(className: "Invite")
        query.getObjectInBackground(withId: inviteId!, block: {(invite: PFObject?, error: Error?) -> Void in
            if error != nil {
                print("Error getting invite")
            }
            else {
                invite?.deleteInBackground()
            }
        })
    }
    
}
