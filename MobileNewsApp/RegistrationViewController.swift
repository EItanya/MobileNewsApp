//
//  RegistrationViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class RegistrationViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //Frames are obselete, plz use constraints instead
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        // Do any additional setup after loading the view.
    }
    
    //Called when login_button calls succesfully
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil {
            print(error)
            return
        }
        
        let accessToken = FBSDKAccessToken.current()
        //Unwrap string safely
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Error signing in with firebase: ", error ?? "")
                return
            }
            print("Successfully logged in with firebase user: ", user ?? "")
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start Graph Request:", error ?? "")
                return
            }
            

            print(result ?? "")
        }
    }
    
    //Calls when facebook logs out using button
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
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
    
    @IBAction func registerBtnClk(_ sender: UIButton) {
        // check to see if form is valid
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                print("Account Creation Failed")
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let ref = FIRDatabase.database().reference().child("users").child(uid)
            let values = ["email": email]
            ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                print("Successfully saved to db")
            })

        })
    }

}
