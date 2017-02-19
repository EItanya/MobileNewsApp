//
//  TabViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/18/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabBarController = self.viewControllers
        let homeViewController = tabBarController?[0] as! HomeViewController
        let settingsViewController = tabBarController?[3] as! SettingsViewController
        homeViewController.userId = self.userId
        settingsViewController.userId = self.userId
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
