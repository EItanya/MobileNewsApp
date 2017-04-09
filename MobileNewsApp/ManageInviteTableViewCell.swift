//
//  ManageInviteTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/12/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

protocol expandInviteDelegate {
    
    func showStoryInfo()
    
}

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
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    @IBOutlet var decisionLabel: UILabel! {
        didSet {
            decisionLabel.isHidden = true
        }
    }
    
    var inviteId: String?
    var storyId: String?
    
    var delegate: ManageInviteTableViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func storyInfoBtn(_ sender: UIButton) {
        hiddenView.isHidden = !hiddenView.isHidden
        delegate?.showStoryInfo()
    }
    
    @IBAction func acceptInviteBtn(_ sender: UIButton) {
        let query = PFQuery(className: "Story")
        query.getObjectInBackground(withId: storyId!, block: {(story: PFObject?, error: Error?) -> Void in
            if error != nil {
                print("Error getting story")
            }
            else {
                let story = Story.convertToStory(story: story!)
                story.addUser(completion: { (error) -> Void in
                    self.acceptBtn.isHidden = true
                    self.deleteBtn.isHidden = true
                    self.decisionLabel.text = "Accepted"
                    self.decisionLabel.isHidden = false
                })
                self.deleteInvite()
            }
        })
    }
    
    @IBAction func rejectInviteBtn(_ sender: UIButton) {
        deleteInvite()
    }
    
    func deleteInvite() {
        let query = PFQuery(className: "Invite")
        query.getObjectInBackground(withId: inviteId!, block: {(invite: PFObject?, error: Error?) -> Void in
            if error != nil {
                print("Error getting invite")
            }
            else {
                invite?.deleteInBackground()
                self.acceptBtn.isHidden = true
                self.deleteBtn.isHidden = true
                self.decisionLabel.text = "Declined"
                self.decisionLabel.isHidden = false
            }
        })
    }
}
