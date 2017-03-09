//
//  StoryInfoViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/9/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class StoryInfoViewController: UIViewController {
    
    var story: Story?
    var users = [User]()
    let user: PFUser = PFUser.current()!
    var admin: Bool = false
    
    
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var leaveButton: LoginScreenButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTable.delegate = self
        userTable.dataSource = self
        
        getListOfUsers()
        setupView()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func getListOfUsers() {
        story?.getUsers(completion: {(users: [User]?, error: Error?) -> Void in
            if error != nil
            {
                print ("there was an error getting the story users")
            }
            else
            {
                self.users = users!
                self.userTable.reloadData()
            }
        })
    }
    
    func setupView() {
        
        if story?.createdBy == self.user.objectId
        {
            //Case when the current User is the Admin.
            self.leaveButton.setTitle("Delete Story", for: .normal)
            self.admin = true
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func leaveStory(_ sender: Any) {
        if admin == true
        {
            //Delete the story for good
            self.story?.deleteStory(completion: {(error: Error?) -> Void in
                if error != nil
                {
                    print("there was an error deleting the story")
                    return
                }
            })
        }
        else
        {
            //Just delete user from Story
            self.story?.removeUser(user: (self.story?.id!)!, completion: {(error: Error?) -> Void in
                if error != nil
                {
                    print("There was an error removing you from the story")
                    return
                }
            })
        }
        //Segue back to profile
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllers[viewControllers.count-3] is ProfileViewController {
            //Code is here so that User does not have to navigate through the Join Story Page again
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
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


//Table View Section
extension StoryInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTable.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = "\((user.firstName)!) \((user.lastName)!)"
        let avatar = UIImage(named: "username")
        cell.avatarImage.image = avatar
        cell.avatarImage.layer.backgroundColor = UIColor.lightGray.cgColor
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.layer.bounds.width/2
        
        return cell
    }
    
}