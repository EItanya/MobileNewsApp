//
//  SettingsViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/18/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource {

    let data:[String] = ["Name", "Email", "Password"]
    let data1:[String] = ["Completed", "Created", "Involved"]
    let data2:[String] = ["Notification", "Theme", "Item c"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        PFUser.logOutInBackground()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        if indexPath.section == 0 {
            cell.textLabel?.text = data[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = data1[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = data2[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        }
        else if section == 1 {
            return data1.count
        }
        return data2.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Profile"
        }
        else if section == 1
        {
            return "Stories"
        }
        else {
            return "Settings"
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
