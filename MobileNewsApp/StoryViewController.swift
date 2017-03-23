//
//  StoryViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/3/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class StoryViewController: UIViewController, UITextViewDelegate {

    
    var story: Story?
    var entry: PFObject?
    var timer: Timer?
    var secondTimer: Timer?
    var counter : Int?
    var user: PFUser?
    var turnOngoing : Bool = false
    var numberOfChars: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var storyField: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    @IBOutlet weak var entryAuthorLabel: UILabel!
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var prevEntryView: UIView!
    
 
    
    //Playing around with some views
//    let fakeModalView = LoadingModalView(frame: CGRect(x: 15, y: 15, width: self.view.bounds.width - 80, height: 100), text: "Logging In")
//    fakeModalView.layer.cornerRadius = 5
//    self.view.addSubview(fakeModalView)
//    fakeModalView.center = self.view.center
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupPreviousEntry()
        user = PFUser.current()
  
        
        titleLabel.text = story?.title
        authorLabel.text = "By: \((story?.author)!)"
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllers[viewControllers.count-2] is ProfileViewController {
            //Code is here so that User does not have to navigate through the Join Story Page again
            let infoImage = UIImage(named: "info")
            let infoButton = UIBarButtonItem(image: infoImage, style: .plain, target: self, action: #selector(StoryViewController.storyInfoSegue))
            infoButton.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = infoButton
        } else {
            //Do Nothing
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Logic to set up page for current writer vs. spectator
        
        if (user?.objectId == story?.currentUser) {
            //It is current user's turn
            setupCurrentTurn()
        } else {
            //Not current turn
            setupSpectator()
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        numberOfChars = newText.characters.count
        print(newText)
        print(numberOfChars)
        updateCharacterCount()
        return numberOfChars <= 250
    }
    
    func updateCharacterCount() {
        if numberOfChars == 0 {
            characterCountLabel.text = ""
        } else {
            characterCountLabel.text = "\(self.numberOfChars)/250"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func setupCurrentTurn() {
//        turnButton.setTitle("Bagin Turn", for: .normal)
        storyField.isSelectable = false
        storyField.isEditable = false
        turnButton.isEnabled = true
    }
    
    func setupSpectator() {
        turnButton.setTitle("(Not Your Turn)", for: .normal)
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
    
    
    
    func setupPreviousEntry() {
        if let lastEntry = self.entry {
            entryTextLabel.text = lastEntry.object(forKey: "text") as! String?
            entryAuthorLabel.text = lastEntry.object(forKey: "author") as! String?
        } else {
            //Must make DB call to get Entry
            let query = PFQuery(className: "Entry")
            query.getObjectInBackground(withId: (self.story?.previousEntry)!, block: {(entry: PFObject?, error: Error?) -> Void in
                if let queryError = error {
                    print(queryError)
                } else {
                    self.entry = entry
                    //Recursive kinda cuz why not, This is such bad code it hurts my head
                    self.setupPreviousEntry()
                }
            })
            
            
        }
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
        let authorName = (self.user?.object(forKey: "first_name") as! String) + " " + (self.user?.object(forKey: "last_name") as! String)
        let entry = Entry(createdBy: (self.user?.objectId)!, text: storyField.text, number: (story?.entryIds.count)! + 1, author: authorName)
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
    
    
    //Function to segue to story Info.
    func storyInfoSegue(sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowInfo", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowInfo" {
            let infoController = segue.destination as! StoryInfoViewController
            infoController.story = self.story
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
