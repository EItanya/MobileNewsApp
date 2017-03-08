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


class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    var userId: String?

    var effectView : UIVisualEffectView?
    
    //Outlets for buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: LoginScreenButton!
    
    //Outlets for all entry Fields
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var logoOutlet: UIImageView!
    @IBOutlet weak var usernameLogo: UIImageView!
    @IBOutlet weak var passwordLogo: UIImageView!
    
    //Outlet for Login Pop Up message
    @IBOutlet var loginWindowView: UIView!
    @IBOutlet var initialFormView: UIView!
    @IBOutlet var registerFormView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        emailField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
    
        
        logoOutlet.image = UIImage(named: "logo_home")
        usernameLogo.image = UIImage(named: "username")
        passwordLogo.image = UIImage(named: "password")
        
        setupViews()
        

//        addUnderlines(textField: firstNameField, offset: CGFloat(integerLiteral: 0))
//        addUnderlines(textField: lastNameField, offset: CGFloat(integerLiteral: 0))
        

        loginWindowView.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    override func viewDidLayoutSubviews() {
//        let offset = CGFloat(integerLiteral: Int(view.bounds.width) - 304)
//        
//        addUnderlines(textField: emailField, offset: offset)
//        addUnderlines(textField: passwordField, offset: offset)
//    }
    
    func setupViews() {
        passwordField.isSecureTextEntry = true
        
        view.addSubview(registerFormView)
        //Setup internal registration view
        registerFormView.center = view.center
        registerFormView.frame = CGRect(x: 0, y: self.passwordField.center.y + 30, width: self.view.bounds.width, height: 286)
        registerFormView.center.x += view.bounds.width
        
        //Setup initial view with login button and facebook button
        view.addSubview(initialFormView)
        initialFormView.frame = CGRect(x: 0, y: self.passwordField.center.y + 45, width: self.view.bounds.width, height: 259)
    }

    
    func addUnderlines(textField: UITextField, offset: CGFloat) {
        let borderWidth = textField.frame.size.width + offset
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: borderWidth, height: textField.frame.size.height)
        
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
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
    
    //Function to animate the login Modal onto the screen
    func loginModalIn () {
        
        effectView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(effectView!)
        
        self.view.addSubview(loginWindowView)
        loginWindowView.center = self.view.center
        loginWindowView.center.y += 15
        loginWindowView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        loginWindowView.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = UIBlurEffect(style: .light)
            self.loginWindowView.alpha = 1
            self.loginWindowView.transform =  CGAffineTransform.identity
        })

    }
    
    //Function to make the modal leave the screen
    func loginModalOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = nil
            self.loginWindowView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.loginWindowView.alpha = 0
        }, completion: {(success: Bool) -> Void in
            self.loginWindowView.removeFromSuperview()
        })
    }
    

    
    @IBAction func login(_ sender: Any) {
        
        animateButton(button: self.loginButton)
        loginModalIn()
        
        let email = emailField.text! as String
        let password = passwordField.text! as String
        
        PFUser.logInWithUsername(inBackground: email, password: password, block: {
            (user: PFUser?, error: Error?) -> Void in
            if error != nil {
                print("Error logging in with username:", error ?? "")
                self.loginModalOut()
                return
            }
            
            print("Logged in successfully with Username")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        })
        
    }
 
    
    
    @IBOutlet weak var fullyRegisterAccountButton: LoginScreenButton!
    @IBAction func fullyRegisterAccount(_ sender: Any) {
        //Code that is now in register.swift Is probably gonna move into a seperate file
        //And will be called from here
        var error = false
        
        if Util.checkEmpty(textField: firstNameField) || Util.checkEmpty(textField: lastNameField) {
            print("First Name Field or Password are empty")
            error = true
        }
        
        if Util.checkEmpty(textField: emailField) {
//            let emailCheck = isValidEmail(testStr: emailField.text! as String)
//            if !emailCheck {
//                //Code to deal with invalid email
//                error = true
//            }
            print("Email Field is empty")
            error = true
        }
        if !Util.checkEmpty(textField: passwordField) {
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


    @IBAction func facebookLogin(_ sender: Any) {
        
        animateButton(button: self.facebookLoginButton)
        loginModalIn()
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"], block: {
            (user: PFUser?, error: Error?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
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
                            myUser.setValue([], forKey: "completed_stories")
                            myUser.setValue([], forKey: "active_stories")
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
                    self.segueToMainApp()
                    
                } else {
                    print("User logged in through Facebook!")
                    self.segueToMainApp()
                }
                
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                self.loginModalOut()
            }
            
            
        })
    }
    
    func segueToMainApp() {
        loginModalOut()
        
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "User") as! TabViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //New function that uses the UI Views
    @IBAction func toRegistration(_ sender: Any) {
        UIView.animate(withDuration: 0.65, delay: 0, options: .curveEaseOut, animations: {
            self.initialFormView.center.x -= self.view.bounds.width
            self.registerFormView.center.x -= self.view.bounds.width
        }, completion: nil)
    }
    
    //New Funcion that uses the UI Views
    @IBAction func backToLoginView(_ sender: Any) {
        UIView.animate(withDuration: 0.65, delay: 0, options: .curveEaseOut, animations: {
            self.initialFormView.center.x += self.view.bounds.width
            self.registerFormView.center.x += self.view.bounds.width
        }, completion: nil)
    }

    


    
    func signIn() {
        
//        let user = parseUser(email: emailField.text! as String, password: passwordField.text! as String, firstName: firstNameField.text! as String, lastName: lastNameField.text! as String)
//        
//        user.signUpInBackground(block: {(succeeded: Bool, error: Error?) -> Void in
//            if error != nil {
//                print("Error is ", error ?? "")
//                return
//            }
//            self.performSegue(withIdentifier: "loginSegue", sender: self)
//            print("User is added successfully")
//        })
        let user = PFUser()
        user.username = emailField.text! as String
        user.password = passwordField.text! as String
        user.email = emailField.text! as String
        user["first_name"] = firstNameField.text! as String
        user["last_name"] = lastNameField.text! as String
        user.setValue([], forKey: "completed_stories")
        user.setValue([], forKey: "active_stories")
        
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
