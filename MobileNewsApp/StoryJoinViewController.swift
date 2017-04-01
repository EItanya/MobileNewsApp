//
//  StoryJoinViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/3/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class StoryJoinViewController: UIViewController {
    
    //Current Story Object
    var story: Story?
    var entry: PFObject?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var previousEntryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = story?.title
        authorLabel.text = story?.createdBy
        let query = PFQuery(className: "Entry")
        query.getObjectInBackground(withId: (self.story?.previousEntry)!, block: {(entry: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error!)
            }
            else {
                self.entry = entry
                self.previousEntryLabel.text! = entry?["text"] as! String
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinStoryBtnClk(_ sender: UIButton) {
        if self.story?.currentUser == "" {
            print("Show StoryViewController")
        }
        story?.addUser(completion: {(error: Error?) -> Void in
            if error != nil {
                print(error!)
            }
            else {
                if self.story?.currentUser == PFUser.current()?.objectId {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Story") as! StoryViewController
                    vc.story = self.story
                    vc.entry = self.entry
                    self.show(vc, sender: self)
                }
                else {
                    let storyboard: UIStoryboard = UIStoryboard(name: "JoinStory", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "JoinThankYou") as! JoinThankYouViewController
                    self.show(vc, sender: self)
                }
            }
        })
    }
    
    //Function to join story

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
