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

class NewUserViewController: UIViewController {
    
    var userId: String?
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
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
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func isValidPassword(testStr:String) -> Bool {
        if testStr.characters.count < 7 {
            //TODO: COde to tell user their password is insufficient
            return false
        } else {
            return true
        }
    }
    
    func checkEmpty(textField:UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty
        {
            //do something if it's not empty
            return false
        } else {
            //TODO: Code to tell user field is empty
            //Return true if empty
            return true
        }
    }
    
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
        
        var error = false
        
        if checkEmpty(textField: firstNameField) || checkEmpty(textField: lastNameField) {
            print("First Name Field or Password are empty")
            error = true
        }
        
        if !checkEmpty(textField: emailField) {
            let emailCheck = isValidEmail(testStr: emailField.text! as String)
            if !emailCheck {
                //Code to deal with invalid email
                error = true
            }
        }
        if !checkEmpty(textField: passwordField) {
            let passwordCHeck = isValidPassword(testStr: passwordField.text! as String)
            if !passwordCHeck {
                //Code to deal with invalid password
                error = true
            }
        }
        if error {
            return
        }
        
        signIn()
        performSegue(withIdentifier: "registrationSegue", sender: self)
    }
    
}
