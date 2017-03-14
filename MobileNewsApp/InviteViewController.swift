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
    var story: Story!
    
    var filteredUsers = [User]()
    var selectedUsers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteTableView.dataSource = self
        inviteTableView.delegate = self
        searchBar.delegate = self
        
        self.hidesBottomBarWhenPushed = true
        
        
        //Cant make rounded corners because three different pieces, not one view :(
//        self.view.layer.cornerRadius = 3
//        self.view.layer.borderColor = UIColor.lightGray.cgColor
//        self.view.layer.borderWidth = 2.0
        
        
        
        UIBarButtonItem.appearance().tintColor = .white
        
        User.getAllUsers(completion: {(users: [User]?, error: Error?) -> Void in
            
            if error != nil {
                print("There was an error retrieving the users")
            }
            else {
                self.users = users!
                self.filteredUsers = users!
//                self.filteredUsers = self.users.map({ (value: User) -> User in
//                    return value
//                })
                self.inviteTableView?.reloadData()
            }
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        if self.selectedUsers.count == 0 {
            return
        }
        
        story.inviteUsers(users: self.selectedUsers, completion: {(error: Error?) -> Void in
            if error != nil {
                print("Something went wrong")
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
            
        })
    }
    
    //Function to close modal
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func selectUser() {
        print("selecting User")
    }
    

}

extension InviteViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! InviteTableViewCell
        
        let user = filteredUsers[indexPath.row]
        cell.user = user
        cell.nameLabel.text = "\((user.firstName)!) \((user.lastName)!)"
        let avatar = UIImage(named: "username")
        cell.avatarImageView.image = avatar
        cell.avatarImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.layer.bounds.width/2
        
        return cell
    }
    
    
    //Gets # of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    //Selects people
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        let cell = self.inviteTableView.cellForRow(at: indexPath) as! InviteTableViewCell
        cell.checkbox.toggleCheckState(true)
        
        
        //Check if user is already selected
        if let index = selectedUsers.index(of: selectedUser.id!) {
            //He is selected
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(selectedUser.id!)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
}

extension InviteViewController: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = searchText.isEmpty ? users : users.filter({(user: User) -> Bool in
            let fullName = user.firstName! + user.lastName!
            
            return fullName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
          
        })
        
        self.inviteTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
