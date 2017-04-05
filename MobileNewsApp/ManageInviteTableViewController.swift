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

    @IBOutlet var inviteTableView: UITableView!
    var user = PFUser.current()
    var invites = [Invite]()
    var stories:[String: PFObject] = [:]
    var fromUsers:[String:PFObject] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInviteList()
        
        inviteTableView.rowHeight = UITableViewAutomaticDimension
        inviteTableView.estimatedRowHeight = 85

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                        }
                        myGroup.leave()
                    })
                }
                myGroup.leave()
            })
        }
        
        myGroup.notify(queue: .main) {
            self.inviteTableView.reloadData()
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
        }
        else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.inviteTableView.bounds.size.width, height: self.inviteTableView.bounds.size.height))
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
        
        cell.titleLabel.text = stories[invite.id]?.object(forKey: "title") as! String
        cell.storyId = stories[invite.id]?.objectId
        cell.inviteId = invite.id
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
