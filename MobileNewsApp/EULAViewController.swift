//
//  EULAViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 4/16/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let title = "Yes"
        let message = "Do you agree to the following terms and services"

        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: {(action: UIAlertAction) in
           self.performSegue(withIdentifier: "agreeSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func segueToMainApp() {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "User") as! TabViewController
        
        self.present(controller, animated: true, completion: nil)
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
