//
//  ManageInviteTableViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/12/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class ManageInviteTableViewController: UITableViewController {

    var user = PFUser.current()
    var invites = [Invite]()
    var stories:[String: PFObject] = [:]
    var fromUsers:[String:PFObject] = [:]
    var userImageDict = [String: UIImage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getInviteList()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInviteList()
    }
    func getInviteList() {
        Invite.getInvitesByUser(userId: (self.user?.objectId)!, completion: {(invites: [Invite]?, error: Error?) -> Void in
            if error != nil {
                //Place error code later
            }
            else {
                self.invites = invites!
                self.getAssociatedStoryandUser()
            }
        })
    }
    
    func getAssociatedStoryandUser() {
        let session = URLSession(configuration: .default)
        let myGroup = DispatchGroup()
        for invite in self.invites {
            myGroup.enter()
            let storyQuery = PFQuery(className: "Story")
            storyQuery.getObjectInBackground(withId: invite.story, block: {(story: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print("Error getting story")
                }
                else {
                    self.stories[invite.id] = story
                    let userQuery = PFUser.query()!
                    myGroup.enter()
                    userQuery.getObjectInBackground(withId: invite.from, block: {(user: PFObject?, err: Error?) -> Void in
                        if err != nil {
                            print("Error getting user")
                        }
                        else {
                            self.fromUsers[invite.id] = user
                            let url = user?.object(forKey: "fb_profile_picture") as! String
                            myGroup.enter()
                            let pictureUrl = URL(string: url)
                            let downloadPicTask = session.dataTask(with: pictureUrl!, completionHandler: { (data, response, error) in
                                if error != nil {
                                    print ("Error in downloading image")
                                }
                                else {
                                    if let res = response as? HTTPURLResponse {
                                        print("Downloaded profile picture with response code \(res.statusCode)")
                                        if let imageData = data {
                                            self.userImageDict[invite.id] = UIImage(data: imageData)
                                        } else {
                                            print("Couldn't get image: Image is nil")
                                        }
                                    } else {
                                        print("Couldn't get response code for some reason")
                                    }
                                }
                                myGroup.leave()
                            })
                            downloadPicTask.resume()

                        }
                        myGroup.leave()
                    })
                }
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numSections = 0
        if invites.count > 0 {
            numSections = 1
            self.tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "You have no invites!"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
        }
        
        return numSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return invites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! ManageInviteTableViewCell
        let invite = invites[indexPath.row]
        
        cell.avatarImg.image = userImageDict[invite.id]
        cell.titleLabel.text = stories[invite.id]?.object(forKey: "title") as! String
        cell.authorLabel.text = "\(fromUsers[invite.id]?.object(forKey: "first_name") as! String) \(fromUsers[invite.id]?.object(forKey: "last_name") as! String)"
        cell.storyId = stories[invite.id]?.objectId
        cell.inviteId = invite.id
        
        cell.delegate = self

        return cell
    }
    
}

extension ManageInviteTableViewController: StoryInfoDelegate {
    func presentStoryInfo(inviteId: String, cell: ManageInviteTableViewCell) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ManageInvites", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteStoryInfo") as! InviteStoryInfoViewController
        
        vc.delegate = cell
        vc.story = Story.convertToStory(story: self.stories[inviteId]!)
        
        
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
