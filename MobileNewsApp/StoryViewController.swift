//
//  StoryViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class StoryViewController: UIViewController {

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
        
        
        storyText.clipsToBounds = true
        storyText.layer.cornerRadius = 5.0
        loadStoryToScreen()
        
        // Do any additional setup after loading the view.
    }

    //Loads current story info to screen
    private func loadStoryToScreen() {
        currentUser = PFUser.current()
        titleLabel?.text = story.title
        authorLabel?.text = "By: \(currentUser!["first_name"]!) \(currentUser!["last_name"]!)"
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
        
        let firstEntry = Entry(createdBy: (currentUser?.objectId)!, text: storyText.text)
        story.firstEntry = firstEntry
        story.previousEntry = firstEntry
        
        self.story.createNewStory(completion: {(story: Story, error: Error?) -> Void in
            print("Story has been created and we are back in StoryViewController")
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
