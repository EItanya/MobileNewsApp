//
//  StoryViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    //Variable representing the screen that sent the user here so we can return to it after
    var entryScreen: String?
    
    @IBOutlet weak var storyText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyText.clipsToBounds = true
        storyText.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    
    
    
    
    @IBAction func submitEntry(_ sender: Any) {
        
    }
    
    @IBAction func exitStoryScreen(_ sender: Any) {
        
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
