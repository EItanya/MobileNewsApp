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

    var userId: String?
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registrationSegue" {
            let tabViewController = segue.destination as! TabViewController
            tabViewController.userId = self.userId
        }
    }
    
//    func isValidEmail(testStr:String) -> Bool {
//        print("validate calendar: \(testStr)")
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        
//        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) {
//            return emailTest.evaluateWithObject(testStr)
//        }
//        return false
//    }
 
    func signIn() {
        let user = PFUser()
        user.username = emailField.text! as String
        user.password = passwordField.text! as String
        user.email = emailField.text! as String
        user["first_name"] = firstNameField.text! as String
        user["last_name"] = lastNameField.text! as String
        
        user.signUpInBackground(block: {(succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print("Error is ", error ?? "")
                return
            }
            print("User is added successfully")
        })
    }
    
    @IBAction func registerBtnClk(_ sender: UIButton) {
        signIn()
    }
}
