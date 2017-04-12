//
//  StoryViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class FirstEntryViewController: UIViewController, UITextViewDelegate {
    //Modal to be displayed when creating a story
    @IBOutlet var savingModal: UIView!

    //Variable representing the screen that sent the user here so we can return to it after
    var entryScreen: String?
    var story : Story!
    var currentUser: PFUser?
    var effectView: UIVisualEffectView?
    var numberOfChars = 0
    var moveDistance: CGFloat?
    var keyboardShowing = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var promptText: UITextView!
    
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If Id is null then we know that the story has not been officially created yet, more minimal functionality
        if story.id == nil {
            submitButton.setTitle("Bring Story Live", for: .normal)
        }
        
        setupTextView()
        
        storyText.delegate = self
        
        
        storyText.clipsToBounds = true
        storyText.layer.cornerRadius = 5.0
        loadStoryToScreen()
        
        // Do any additional setup after loading the view.
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        numberOfChars = newText.characters.count
        updateCharacterCount()
        return numberOfChars <= 250
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if storyText.hasText {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
    
    func updateCharacterCount() {
        characterCountLabel.text = "\(numberOfChars)/250"
    }
    
    
    

    //Loads current story info to screen
    private func loadStoryToScreen() {
        currentUser = PFUser.current()
        titleLabel?.text = story.title
        authorLabel?.text = "By: \(currentUser!["first_name"]!) \(currentUser!["last_name"]!)"
    }
    
    func setupTextView() {
        //Simply styling for text Field
        let shadowColor :  CGFloat = 155.0 / 255.0
        let layer = storyText.layer
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(displayP3Red: shadowColor, green: shadowColor, blue: shadowColor, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        layer.borderWidth = 2
        layer.borderColor = UIColor(displayP3Red: 68/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
        
//        placeHolderLabel.isHidden = true
        //Setup placehodler label
//        placeholderLabel = UILabel(frame: CGRect(x: storyText.frame.minX + 10, y: storyText.frame.minY + 10, width: storyText.frame.size.width - 20, height: storyText.frame.size.height-20))
//        storyText.addSubview(placeholderLabel)
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FirstEntryViewController.resignKeyboard))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.storyText.inputAccessoryView = doneToolbar
        
        promptText.text = self.story?.prompt!
    }
    
    func resignKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    
    
    @IBAction func submitEntry(_ sender: Any) {
        var error: Bool = false
        
        //Check that textView Is not empty
        if Util.checkEmptyView(textField: storyText) {
            print("text View is empty")
            error = true
        }
        
        
        
        if error {
            return
        }
        
        savingModalIn()
        
        let authorName = (self.currentUser?.object(forKey: "first_name") as! String) + " " + (self.currentUser?.object(forKey: "last_name") as! String)
        
        
        let firstEntry = Entry(createdBy: (currentUser?.objectId)!, text: storyText.text, number: 1, author: authorName)
        //Code to count words and add to story
        story.totalWordCount = Util.countWords(text: storyText.text)
        story.author = "\(currentUser?.object(forKey: "first_name") as! String) \(currentUser?.object(forKey: "last_name") as! String)"
//        story.author = currentUser?.object(forKey: "first_name") as! String + currentUser?.object(forKey: "last_name") as! String
        
        self.story.createNewStory(entry: firstEntry, completion: {(story: Story?, error: Error?) -> Void in
            print("Story has been created and we are back in StoryViewController")
            
            //Code to transition back to Home screen after story is created in DB
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
//            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "User") as! UITabBarController
//            
//            UIView.transition(with: self.view, duration: 0.5, options: .curveLinear, animations: {() -> Void in
//                UIApplication.shared.keyWindow?.rootViewController = viewController
//            }, completion: nil)
            self.savingModalOut()
            self.performSegue(withIdentifier: "thanksSegue", sender: self)

        })
        
    }
    
    @IBAction func exitStoryScreen(_ sender: Any) {
        
    }
    
    //Function to animate the login Modal onto the screen
    func savingModalIn () {
        
        effectView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(effectView!)
        
        self.view.addSubview(savingModal)
        savingModal.center = self.view.center
        savingModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        savingModal.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = UIBlurEffect(style: .light)
            self.savingModal.alpha = 1
            self.savingModal.transform =  CGAffineTransform.identity
        })
        
    }
    
    //Function to make the modal leave the screen
    func savingModalOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = nil
            self.savingModal.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.savingModal.alpha = 0
        }, completion: {(success: Bool) -> Void in
            self.savingModal.removeFromSuperview()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
