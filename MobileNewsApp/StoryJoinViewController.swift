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
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var turnsLeftLabel: UILabel!
    @IBOutlet var promptTextView: UITextView!
    @IBOutlet var previousEntryTextView: UITextView!
    @IBOutlet var peopleAheadLabel: UILabel!
    
    var joined = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let min = Int(story!.timeLimit! / 60)
        let seconds = Int(story!.timeLimit!) % 60
        if min == 0 {
            timeLabel.text = "\(seconds) s. per turn"
        }
        else if seconds == 0 {
            timeLabel.text = "\(min) m. per turn"
        }
        else {
            timeLabel.text = "\(min) m. \(seconds) s. per turn"
        }
        turnsLeftLabel.text = "\(story!.currentEntry!)/\(story!.totalTurns!) turns"
        let currentUserId = story?.currentUser
        var peopleInLine = 0
        if currentUserId != "" {
            peopleInLine = (story?.users.count)! - (story?.users.index(of: currentUserId!)!)!
        }
        peopleAheadLabel.text = "\(peopleInLine) people ahead"
        titleLabel.text = story?.title
        promptTextView.text = story?.prompt!
        let query = PFQuery(className: "Entry")
        query.getObjectInBackground(withId: (self.story?.previousEntry)!, block: {(entry: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error!)
            }
            else {
                self.entry = entry
                self.previousEntryTextView.text = entry?["text"] as! String
            }
        })
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: promptTextView.frame.minX, y: promptTextView.frame.minY - 55, width: self.view.frame.size.width - (promptTextView.frame.minX*2), height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.view.layer.addSublayer(topBorder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinStoryBtnClk(_ sender: UIButton) {
        if joined == false {
            joined = true
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
        else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Story") as! StoryViewController
            vc.story = self.story
            vc.entry = self.entry
            self.show(vc, sender: self)
        }
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
