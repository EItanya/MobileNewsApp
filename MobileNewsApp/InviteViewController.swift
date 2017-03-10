//
//  InviteViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    @IBOutlet weak var inviteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteTableView.dataSource = self
        inviteTableView.delegate = self
        searchBar.delegate = self
        
        self.hidesBottomBarWhenPushed = true
        
        User.getAllUsers(completion: {(users: [User]?, error: Error?) -> Void in
            
            if error != nil {
                print("There was an error retrieving the users")
            }
            else {
                self.users = users!
                self.inviteTableView?.reloadData()
            }
            
        })
        // Do any additional setup after loading the view.
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
    
    //Function to send Invites
    @IBAction func sendInvites(_ sender: Any) {
        
    }
    
    //Function to close modal
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    

}

extension InviteViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! InviteTableViewCell
        
        let user = users[indexPath.row]
        cell.user = user
        cell.nameLabel.text = "\((user.firstName)!) \((user.lastName)!)"
        let avatar = UIImage(named: "username")
        cell.avatarImageView.image = avatar
        cell.avatarImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.layer.bounds.width/2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
}

extension InviteViewController: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter Data Here
    }
    
    
}
