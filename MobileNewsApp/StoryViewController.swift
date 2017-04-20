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
    var moveDistance: CGFloat?
    var keyboardShowing = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var storyField: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var turnNumber: UILabel!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    @IBOutlet weak var entryAuthorLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryTextView: UITextView!
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
        storyField.delegate = self
  
        
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
        
        turnNumber.text = "Turn: \((self.story?.currentEntry!)!)/\(((self.story?.totalTurns!)!)) "
        
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        if storyField.hasText {
            placeholderText.isHidden = true
        } else {
            placeholderText.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        numberOfChars = newText.characters.count
        updateCharacterCount()
        return numberOfChars <= 250
    }
    
    
    func updateCharacterCount() {
        characterCountLabel.text = "\(numberOfChars)/250"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            let keyboardMinY = self.view.frame.height - keyboardHeight
            let textViewBottom = self.storyField.frame.maxY
            
            if (keyboardMinY <= textViewBottom && !self.keyboardShowing) {
                let distance = textViewBottom - keyboardMinY
                if distance >= CGFloat(0) {
                    self.moveDistance = distance
                    self.keyboardShowing = true
                    self.view.frame.origin.y -= self.moveDistance!
                }
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        if self.moveDistance != nil && self.keyboardShowing {
            if self.moveDistance! >= CGFloat(0) {
                self.view.frame.origin.y += self.moveDistance!
                self.keyboardShowing = false
            }
        }
        //Once keyboard disappears, restore original positions
        //        self.view.frame.origin.y += 150
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
        
        storyField.autocorrectionType = UITextAutocorrectionType.yes
        storyField.spellCheckingType = UITextSpellCheckingType.yes
        storyField.delegate = self
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: prevEntryView.frame.minX, y: prevEntryView.frame.minY + 10, width: self.view.frame.size.width - (prevEntryView.frame.minX*2), height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.view.layer.addSublayer(topBorder)
        
        
        entryTextView.isSelectable = false
        entryTextView.isEditable = false
    }
    
    
    
    func setupPreviousEntry() {
        if let lastEntry = self.entry {
            entryTextView.text = lastEntry.object(forKey: "text") as! String?
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
                let query = PFQuery(className: "Story")
                query.getObjectInBackground(withId: (self.story?.id)!, block: {(object: PFObject?, error: Error?) -> Void in
                    if error != nil {
                        print("Could not get story object")
                    }
                    else {
                    let isComplete = object?["completed"] as! Bool
                    if isComplete {
                            let story = Story(story: object!)
                            story.getEntries(completion: { (error: Error?) -> Void in
                                if error != nil {
                                    print("Error querying for entries")
                                }
                                else {
                                story.entries.sort(by: {$0.number! < $1.number! })
                                let pdfComposer = PDFComposer(story: story)
                                let pdfHTML = pdfComposer.renderHTML()
                                let HTMLContent = pdfHTML
                                let url = pdfComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent!)
                                pdfComposer.uploadToS3(url: url)
                                }
                            })
                        }
                    }
                })
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
            self.story?.startUserTurn()
            storyField.isSelectable = true
            storyField.isEditable = true
        } else {
            turnOngoing = false
            self.timer?.invalidate()
            self.secondTimer?.invalidate()
            endTurn()
        }
        UIView.transition(with: self.turnButton, duration: 0.5, options: .transitionFlipFromBottom, animations: {() -> Void in
            if self.turnOngoing == true {
                self.turnButton.setTitle("End Turn", for: .normal)
                self.turnButton.backgroundColor = UIColor.red
            } else {
                self.turnButton.setTitle("(Thanks for writing)", for: .normal)
                self.turnButton.backgroundColor = UIColor(colorLiteralRed: 98/255, green: 208/255, blue: 232/255, alpha: 1)
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
