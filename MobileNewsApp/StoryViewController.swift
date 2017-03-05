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
    var secondTimer: Timer?
    var counter : Int?
    var user: PFUser?
    var turnOngoing : Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var storyField: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
 
    
    //Playing around with some views
//    let fakeModalView = LoadingModalView(frame: CGRect(x: 15, y: 15, width: self.view.bounds.width - 80, height: 100), text: "Logging In")
//    fakeModalView.layer.cornerRadius = 5
//    self.view.addSubview(fakeModalView)
//    fakeModalView.center = self.view.center
    
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
        storyField.isSelectable = false
        storyField.isEditable = false
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
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    //Setup timer to keep track of persons writing time.
    func setupTimer() {
        self.counter = Int((self.story?.timeLimit!)!)
        self.timer = Timer.scheduledTimer(timeInterval: (self.story?.timeLimit)!, target: self, selector: #selector(StoryViewController.endTurn), userInfo: nil, repeats: false)
        self.secondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StoryViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    //Function to end turn, and submit story, and other such things
    func endTurn() {
        self.timerLabel.text = ""
        turnButton.isEnabled = false
        storyField.isSelectable = false
        storyField.isEditable = false
        let entry = Entry(createdBy: (self.user?.objectId)!, text: storyField.text, number: (story?.entryIds.count)! + 1)
        story?.updateStoryAfterTurn(entry: entry, completion: {(error: Error?) -> Void in
            if error != nil {
            } else {
                self.popTwoIfJoin()
            }
        })
    }
    
    //Code that will only fire if the User joined the story for the first time
    func popTwoIfJoin() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllers[viewControllers.count-2] is StoryJoinViewController {
            //Code is here so that User does not have to navigate through the Join Story Page again
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        } else {
            //Do Nothing
        }
    }
    
    func updateTimer() {
        let minute = counter! / 60
        let seconds = counter! % 60
        self.timerLabel.text = "\(minute):\(seconds)"
        self.counter! -= 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func turnButtonPress(_ sender: Any) {
        if turnOngoing == false {
           turnOngoing = true
            setupTimer()
            storyField.isSelectable = true
            storyField.isEditable = true
        } else {
            turnOngoing = false
            self.timer?.invalidate()
            self.secondTimer?.invalidate()
            endTurn()
        }
        UIView.transition(with: self.turnButton, duration: 0.5, options: .transitionFlipFromBottom, animations: {() -> Void in
            self.turnButton.setTitle("End Turn", for: .normal)
            if self.turnOngoing == true {
                self.turnButton.backgroundColor = UIColor.red
            } else {
                self.turnButton.backgroundColor = UIColor.blue
            }
            
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
