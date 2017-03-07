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

    //Variable representing the screen that sent the user here so we can return to it after
    var entryScreen: String?
    var story : Story!
    var currentUser: PFUser?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        let firstEntry = Entry(createdBy: (currentUser?.objectId)!, text: storyText.text, number: 1)
        //Code to count words and add to story
        story.totalWordCount = Util.countWords(text: storyText.text)
        story.author = "\(currentUser?.object(forKey: "first_name") as! String) \(currentUser?.object(forKey: "last_name") as! String)"
//        story.author = currentUser?.object(forKey: "first_name") as! String + currentUser?.object(forKey: "last_name") as! String
        
        self.story.createNewStory(entry: firstEntry, completion: {(story: Story?, error: Error?) -> Void in
            print("Story has been created and we are back in StoryViewController")
            
            //Code to transition back to Home screen after story is created in DB
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "User") as! UITabBarController
            
            UIView.transition(with: self.view, duration: 0.5, options: .curveLinear, animations: {() -> Void in
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }, completion: nil)
            

        })
        
    }
    
    @IBAction func exitStoryScreen(_ sender: Any) {
        
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
