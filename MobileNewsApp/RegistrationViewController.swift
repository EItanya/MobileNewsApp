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
 
    
    @IBAction func SignIn(_ sender: UIButton) {


    }
    
    @IBAction func registerBtnClk(_ sender: UIButton) {
    }
}
