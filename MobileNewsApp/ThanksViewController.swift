//
//  ThanksViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/7/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllers[viewControllers.count-2] is FirstEntryViewController {
            //Code is here so that User does not have to navigate through the Join Story Page again
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
        } else {
            //Do Nothing
        }
        
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
