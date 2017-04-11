//
//  ManageInviteTableViewCell.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/12/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

protocol StoryInfoDelegate {
    func presentStoryInfo(inviteId: String, cell: ManageInviteTableViewCell)
}

class ManageInviteTableViewCell: UITableViewCell, InviteStoryInfoDelegate {

    var inviteId: String?
    var storyId: String?
    
    @IBOutlet var avatarImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var declineBtn: UIButton!
    @IBOutlet var decisionLabel: UILabel! {
        didSet {
            decisionLabel.isHidden = true
        }
    }
    
    var delegate: ManageInviteTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnClk(_ sender: UIButton) {
        acceptInvite()
    }
    
    func acceptInvite() {
        let query = PFQuery(className: "Story")
        query.getObjectInBackground(withId: storyId!, block: {(story: PFObject?, error: Error?) -> Void in
            if error != nil {
                print("Error getting story")
            }
            else {
                let story = Story.convertToStory(story: story!)
                story.addUser(completion: { (error) -> Void in
                    self.acceptBtn.isHidden = true
                    self.declineBtn.isHidden = true
                    self.decisionLabel.text = "Accepted"
                    self.decisionLabel.isHidden = false
                })
                self.deleteInvite()
            }
        })
    }

    @IBAction func declineBtnClk(_ sender: UIButton) {
        declineInvite()
    }
    
    func declineInvite() {
        deleteInvite()
        self.decisionLabel.text = "Declined"
    }
    
    @IBAction func storyInfoBtnClk(_ sender: UIButton) {
        delegate?.presentStoryInfo(inviteId: inviteId!, cell: self)
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
                self.declineBtn.isHidden = true
                self.decisionLabel.isHidden = false
            }
        })
    }
    
}
