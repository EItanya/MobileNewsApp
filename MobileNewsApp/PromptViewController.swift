//
//  PromptViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/19/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class PromptViewController: UIViewController {
    

    var selecedPrompt: String = ""
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var storyField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //Function to create function in DB
    func createStory() {
        
        //hey current user
        let user: PFUser = PFUser.current()!
        
        //Set up story object to be saved
        let story = PFObject(className: "Story")
        story["genre"] = genreField.text
        story["title"] = titleField.text
        story["prompt"] = self.selecedPrompt
        story["created_by"] = user.objectId! as String
        
        let storyDict : [String: Any] = [
            "genre" : genreField.text!,
            "title" : titleField.text!,
            "prompt": self.selecedPrompt,
            "created_by": user.objectId! as String
        ]
        
        let entryDict : [String: Any] = [
            "text": storyField.text,
            "created_by": user.objectId! as String
        ]
        
        
        //Setup entry object to be saved
        let entry = PFObject(className: "Entry")
        entry["text"] = storyField.text
        entry["created_by"] = user.objectId! as String
        
        
        let objectArray : [PFObject] = [story, entry]
        
        //Possible change to cloud code to do all in one call
        PFCloud.callFunction(inBackground: "createStory", withParameters: ["entry": entryDict, "story": storyDict], block: {
            (response: Any?, error: Error?) -> Void in
            print("Called Cloud Code")
            
        })
        
        
        //Save entry and story in Background
//        PFObject.saveAll(inBackground: objectArray, block: {(success: Bool, error: Error?) -> Void in
//            if success {
//                print("Entry and Story saved to DB")
//                //Call Cloud function to align data in DB
//                //Make segue to story section
//            }
//            else {
//                print("Error saving to DB", error ?? "")
//            }
//        })
        
    }
    
    
    func checkEmpty(textField:UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty { return false }
        else {  return true }
    }
    
    func checkEmptyView(textField:UITextView) -> Bool {
        if let text = textField.text, !text.isEmpty { return false }
        else {  return true }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createStoryButton(_ sender: Any) {
        //Check here that all of the fields are filled out
        var error = false
        if checkEmpty(textField: titleField) {
            print("text Field is empty")
            error = true
        }
        if checkEmpty(textField: genreField) {
            print("genre field is empty")
            error = true
        }
        if checkEmptyView(textField: storyField) {
            print("text View is empty")
            error = true
        }
        if error { return }
        
        createStory()
        
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
