//
//  RegistrationViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4

class RegistrationViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func SignIn(_ sender: UIButton) {
        
  
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"], block: {
            (user: PFUser?, error: Error?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                let requestParameters = ["fields": "id, email, first_name, last_name"]
                let userDetails : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: requestParameters)
                
                userDetails.start(completionHandler: { (connection, result, error) -> Void in
                    if error != nil {
                        print("Error getting Facebook Info", error ?? "")
                        return
                    } else if result != nil {
                        //Turn result into Dictionary
                        let data:[String:AnyObject] = result as! [String : AnyObject]
                        //Gather Data
                        let userId:String = data["id"] as! String
                        let userFirstName:String? = data["first_name"] as? String
                        let userLastName:String? = data["last_name"] as? String
                        let userEmail:String? = data["email"] as? String
                        
                        //Get Current USer
                        let myUser:PFUser = PFUser.current()!
                        //print(myUser)
                        //Set My User values to add data to parse user
                        if(userFirstName != nil) { myUser.setValue(userFirstName, forKey: "first_name") }
                        if(userLastName != nil) { myUser.setValue(userLastName, forKey: "last_name") }
                        if(userEmail != nil) { myUser.setValue(userEmail, forKey: "email") }
                        
                        //Future to save to DB
                            
                    }
                })
                
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
 
        })

    }
    
    @IBAction func registerBtnClk(_ sender: UIButton) {
    }
}
