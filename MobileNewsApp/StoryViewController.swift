//
//  StoryViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/3/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class StoryViewController: UIViewController {

    var story: Story?
    var timer: Timer?
    var user: PFUser?
    var turnOngoing : Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var storyField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        user = PFUser.current()
        //Logic to set up page for current writer vs. spectator
        if (user?.objectId == story?.currentUser) {
            //It is current user's turn
            setupCurrentTurn()
        } else {
            //Not current turn
            setupSpectator()
        }
        // Do any additional setup after loading the view.
    }
    
    func setupCurrentTurn() {
        turnButton.isEnabled = true
    }
    
    func setupSpectator() {
        storyField.isSelectable = false
        storyField.isEditable = false
        turnButton.isEnabled = false
    }
    
    func setupTextView() {
        //Simply styling for text Field
        let shadowColor :  CGFloat = 155.0 / 255.0
        let layer = storyField.layer
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(displayP3Red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
    }
    
    //Setup timer to keep track of persons writing time.
    func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: (self.story?.timeLimit)!, repeats: false, block: {(timer: Timer) -> Void in
            print("timer is set up")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func turnButtonPress(_ sender: Any) {
        if turnOngoing == false {
           turnOngoing = true
            setupTimer()
        } else {
            turnOngoing = false
        }
        UIView.transition(with: self.turnButton, duration: 0.5, options: .transitionFlipFromBottom, animations: {() -> Void in
            self.turnButton.setTitle("End Turn", for: .normal)
        }, completion: nil)
        
        
        
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
