//
//  InviteStoryInfoViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 4/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

protocol InviteStoryInfoDelegate {
    
    func acceptInvite()
    
    func declineInvite()
}

class InviteStoryInfoViewController: UIViewController {

    var delegate: ManageInviteTableViewCell?
    var story: Story?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var peopleAheadLabel: UILabel!
    @IBOutlet var promptTextView: UITextView!
    @IBOutlet var previousEntryTextView: UITextView!
    
    
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
        turnLabel.text = "\(story!.currentEntry!)/\(story!.totalTurns!) turns"
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
                self.previousEntryTextView.text = entry?["text"] as! String
            }
        })
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: promptTextView.frame.minX + 15, y: promptTextView.frame.minY + 80, width: promptTextView.frame.width, height: 1.0)
        topBorder.backgroundColor = UIColor.black.cgColor
        self.view.layer.addSublayer(topBorder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptBtnClk(_ sender: UIButton) {
        delegate?.acceptInvite()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func declineBtnClk(_ sender: UIButton) {
        delegate?.declineInvite()
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
