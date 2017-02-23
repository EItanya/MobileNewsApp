//
//  LoginViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/18/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var userId: String?

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: LoginScreenButton!
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var logInMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.firstNameField.center.x += self.view.bounds.width
        self.lastNameField.center.x += self.view.bounds.width
        self.fullyRegisterAccountButton.center.x += self.view.bounds.width
        self.logInMessage.center.x -= self.view.bounds.width
        self.backToLoginButton.center.x += self.view.frame.width

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateButton(button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                       button.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )

    }
    
    func logInMessageLoad() {
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.logInMessage.center.x += self.view.bounds.width
        },
                       completion: { Void in()  }
        )
        
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        animateButton(button: self.loginButton)
        
        let email = emailField.text! as String
        let password = passwordField.text! as String
        
        PFUser.logInWithUsername(inBackground: email, password: password, block: {
            (user: PFUser?, error: Error?) -> Void in
            if error != nil {
                print("Error logging in with username:", error ?? "")
                return
            }
            
            print("Logged in successfully with Username")
//            let storyboard = UIStoryboard(name: "User", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "User") as! TabViewController
//            
//            self.present(controller, animated: true, completion: nil)
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        })
        
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func register(_ sender: Any) {
        
        //Might have to add a segue here in animations don't work
//        UIView.animate(withDuration: 1.0, animations: {
//            self.registerButton.center.x -= self.view.frame.width
//            self.loginButton.center.x -= self.view.frame.width
//            self.facebookLoginButton.center.x -= self.view.frame.width
//            
//
//        })
        
        UIView.animate(withDuration: 1.0, delay: 0, animations: {

            self.registerButton.center.x -= self.view.frame.width
            self.loginButton.center.x -= self.view.frame.width
            self.facebookLoginButton.center.x -= self.view.frame.width
            self.firstNameField.center.x -= self.view.frame.width
            self.lastNameField.center.x -= self.view.frame.width
            self.fullyRegisterAccountButton.center.x -= self.view.bounds.width
            self.backToLoginButton.center.x -= self.view.frame.width
        }, completion: nil)
        
    }
    
    
    
    @IBOutlet weak var fullyRegisterAccountButton: LoginScreenButton!
    @IBAction func fullyRegisterAccount(_ sender: Any) {
        //Code that is now in register.swift Is probably gonna move into a seperate file
        //And will be called from here
        var error = false
        
        if checkEmpty(textField: firstNameField) || checkEmpty(textField: lastNameField) {
            print("First Name Field or Password are empty")
            error = true
        }
        
        if checkEmpty(textField: emailField) {
//            let emailCheck = isValidEmail(testStr: emailField.text! as String)
//            if !emailCheck {
//                //Code to deal with invalid email
//                error = true
//            }
            print("Email Field is empty")
            error = true
        }
        if !checkEmpty(textField: passwordField) {
            if (passwordField.text?.characters.count)! < 7 {
                //Code to deal with invalid password
                print("Password is too short")
                error = true
            }
        } else { error = true }
        if error {
            return
        }
        
        signIn()

    }
    @IBOutlet weak var backToLoginButton: LoginScreenButton!

    @IBAction func backToLogin(_ sender: Any) {
        //Send the register page back into the side
        UIView.animate(withDuration: 1.0, delay: 0, animations: {
            
            self.registerButton.center.x += self.view.frame.width
            self.loginButton.center.x += self.view.frame.width
            self.facebookLoginButton.center.x += self.view.frame.width
            self.firstNameField.center.x += self.view.frame.width
            self.lastNameField.center.x += self.view.frame.width
            self.fullyRegisterAccountButton.center.x += self.view.bounds.width
            self.backToLoginButton.center.x += self.view.frame.width
        }, completion: nil)
        
    }

    @IBAction func facebookLogin(_ sender: Any) {
        
        animateButton(button: self.facebookLoginButton)
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"], block: {
            (user: PFUser?, error: Error?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                let requestParameters = ["fields": "id, email, first_name, last_name, picture.type(large)"]
                let userDetails : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: requestParameters)
                
                userDetails.start(completionHandler: { (connection, result, error) -> Void in
                    if error != nil {
                        print("Error getting Facebook Info", error ?? "")
                        return
                    } else if result != nil {
                        //Get Current USer
                        let myUser:PFUser = PFUser.current()!
                        //Turn result into Dictionary
                        let data:[String:AnyObject] = result as! [String : AnyObject]
                        //Gather Data
                        let userId:String? = data["id"] as? String
                        let userFirstName:String? = data["first_name"] as? String
                        let userLastName:String? = data["last_name"] as? String
                        let userEmail:String? = data["email"] as? String
                        
                        self.userId = userId
                        let storyboard = UIStoryboard(name: "User", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "User") as! TabViewController
                        
                        self.present(controller, animated: true, completion: nil)
                        
                        //Grab image URL, JSON is tricky in swift 3
                        if let image = data["picture"] as? [String: Any] {
                            if let imageData = image["data"] as? [String:Any] {
                                let userImage:String? = imageData["url"] as! String?
                                if (userImage != nil) { myUser.setValue(userImage, forKey: "fb_profile_picture") }
                            }
                        }
                        
                        //Set My User values to add data to parse user
                        if(userId != nil) { myUser.setValue(userId, forKey: "fb_id") }
                        if(userFirstName != nil) { myUser.setValue(userFirstName, forKey: "first_name") }
                        if(userLastName != nil) { myUser.setValue(userLastName, forKey: "last_name") }
                        if(userEmail != nil) { myUser.setValue(userEmail, forKey: "email") }
                        //Save User data back to Parse
                        myUser.saveInBackground(block: {(success: Bool, error: Error?) -> Void in
                            if error != nil {
                                print("Error saving User to DB", error ?? "")
                                return
                            }
                            else if success {
                                print("User successfully saved to DB")
                            }
                        })
                        
                        
                    }
                })
                
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
            
        })
    }
    
//    func isValidEmail(testStr:String) -> Bool {
//        print("validate emilId: \(testStr)")
//        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        let result = emailTest.evaluate(with: testStr)
//        return result
//    }
    

    
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
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            print("User is added successfully")
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginSegue" {
            let tabBarController = segue.destination as! TabViewController
            tabBarController.userId = self.userId
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
