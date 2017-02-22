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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.red
        
        // Do any additional setup after loading the view.
    }
    
    
    //Function to create function in DB
    func createStory() {
        
        activityIndicator.startAnimating()
        
        //hey current user
        let user: PFUser = PFUser.current()!
        
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
        
        //Possible change to cloud code to do all in one call
        PFCloud.callFunction(inBackground: "createStory", withParameters: ["entry": entryDict, "story": storyDict], block: {
            (response: Any?, error: Error?) -> Void in
            //Edit later to include message about server issues.
            if error != nil {
                print("Error saving data to DB:", error ?? "")
            } else {
                self.activityIndicator.stopAnimating()
                print(response as! String)
                //Code to segue
            }
        })
        
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
        
        //
        createStory()
        
        //Segue to next screen, probably
        
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
