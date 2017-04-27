//
//  ProfileSettingViewController.swift
//  MobileNewsApp
//
//  Created by Mantu Nguyen on 4/16/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class ProfileSettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var retypePasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        let user = PFUser.current()
        
        self.profileImage.layer.cornerRadius = 10.0
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 3.0
        
        let firstN = (user?.object(forKey: "first_name") as! String)
        let lastN = (user?.object(forKey: "last_name") as! String)
        let email = (user?.object(forKey: "email") as! String)
        
        firstNameText.text = firstN
        lastNameText.text = lastN
        emailText.text = email
    
        
        let session = URLSession(configuration: .default)
        let url = user!["fb_profile_picture"] as? String
        if url != nil
        {
            let pictureUrl = URL(string: url!)
            
            let downloadPicTask = session.dataTask(with: pictureUrl!, completionHandler: { (data, response, error) in
                if error != nil {
                    print ("Error in downloading image")
                }
                else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded profile picture with response code \(res.statusCode)")
                        if let imageData = data {
                            self.profileImage.image = UIImage(data: imageData)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
                
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.image = UIImage(data: imageData)
                        print("image refreshed")
                    }
                }
            })
            downloadPicTask.resume()
        }
        else
        {
            self.profileImage.image = #imageLiteral(resourceName: "default-avatar")
        }
        
        
//        if let image = data["picture"] as? [String: Any] {
//            if let imageData = image["data"] as? [String:Any] {
//                let userImage:String? = imageData["url"] as! String?
//                if (userImage != nil) { myUser.setValue(userImage, forKey: "fb_profile_picture") }
//            }
//        }
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
    
    @IBAction func Done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveProfile(_ sender: Any) {
        let user:PFUser = PFUser.current()!
        let profileImageData = UIImageJPEGRepresentation(profileImage.image!, 1)
        
        //var error = false
        
        if checkEmpty(textField: firstNameText) || checkEmpty(textField: lastNameText) {
            print("First Name Field or Password are empty")
            
            let alert = UIAlertController(title: "Alert", message: "Please type in your name", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if checkEmpty(textField: emailText) {
            let emailCheck = isValidEmail(testStr: emailText.text! as String)
            if !emailCheck {
                //Code to deal with invalid email
                let alert = UIAlertController(title: "Alert", message: "Please type a valid email", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        if !checkEmpty(textField: passwordText) {
            let passwordCHeck = isValidPassword(testStr: passwordText.text! as String)
            if !passwordCHeck {
                //Code to deal with invalid password
                let alert = UIAlertController(title: "Alert", message: "Please type a valid email", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        //if error {
        //    return
        //}
        
        
        if((passwordText.text?.isEmpty)! && (firstNameText.text?.isEmpty)! && (lastNameText.text?.isEmpty)! && (profileImageData == nil))
        {
            let alert = UIAlertController(title: "Alert", message: "There is an empty field", preferredStyle: UIAlertControllerStyle.alert)
        
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let uFirst = firstNameText.text
        let uLast = lastNameText.text
        let uMail = emailText.text
        let userName = emailText.text
        
        user.setObject(uFirst!, forKey: "first_name")
        user.setObject(uLast!, forKey: "last_name")
        user.setObject(uMail!, forKey: "email")
        user.setObject(userName!, forKey: "username")
        
        if(!(passwordText.text?.isEmpty)!)
        {
            let uPass = passwordText.text
            user.password = uPass
        }
        
        if(profileImageData != nil)
        {
            let profileObj = PFFile(data:profileImageData!)
            user.setObject(profileObj!, forKey: "profile_image")
        }
        
        SwiftSpinner.show("Saving...")

        user.saveInBackground { (success:Bool, error:Error?) -> Void in
            SwiftSpinner.hide()
            
            if(error != nil)
            {
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if(success)
            {
                let userMessage = "Profile details successfully updated"
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
                 
                    self.dismiss(animated: true, completion: { () -> Void in
                    })
                })
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
