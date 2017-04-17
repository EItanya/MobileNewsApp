//
//  CompletedStoryTableViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/7/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse
import MGSwipeTableCell
import FBSDKCoreKit
import FBSDKShareKit

class CompletedStoryTableViewController: UITableViewController {
    
    var story: Story?
    var entryArray = [Entry]()
    var effectView: UIVisualEffectView?
    var userImageDict: [String: UIImage] = [:]
    var currentUser: User?
    
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loadingModal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        self.tableView.separatorStyle = .none
        
        titleLabel.text = story?.title
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: story!.url) as URL!
        content.contentTitle = "\(story!.title!)"
        content.contentDescription = "Add a caption"
        content.imageURL = NSURL(string: "https://s3-us-west-2.amazonaws.com/mobile-news-app/logonew_720.png") as URL!
        
        let fbkShareBtn: FBSDKShareButton = FBSDKShareButton()
        fbkShareBtn.shareContent = content
        fbkShareBtn.frame = CGRect(x: headerView.center.x + 90, y: headerView.center.y + 15, width: 90, height: 25)
        headerView.addSubview(fbkShareBtn)
        
        getEntryData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEntryData() {
        //loadingModalIn()
        let myGroup = DispatchGroup()
        myGroup.enter()
        PFUser.current()?.fetchInBackground(block: {(object, error) -> Void in
            if (error != nil) {
                print(error)
            }
            else {
                self.currentUser = User(pfobject: object!)
            }
            myGroup.leave()
        })
        myGroup.notify(queue: .main) {
           self.story?.getEntries(completion: {(error: Error?) -> Void in
                if error != nil
                {
                    print("Error getting Entries")
                }
                else
                {
                    //Code to populate list
                    //Right now just points to same data, might need to update later
                    self.entryArray = (self.story?.entries)!
                    self.entryArray.sort(by: {$0.number! < $1.number! })
                }
                //self.loadingModalOut()
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! CompletedStoryTableViewCell
        
        let currentEntry = entryArray[indexPath.row]
        
        let reportButton = MGSwipeButton(title: "Report", backgroundColor: UIColor.red)
        {
            (sender: MGSwipeTableCell!) in
            
            print("\(currentEntry.author!), \(currentEntry.number!)")
            return true
            
        }
        reportButton.titleLabel?.font = UIFont(name: "DIN", size: 15)

        if (currentUser?.blockedUsers?.contains(currentEntry.createdBy!))! {
            cell.entryLabel.text = "Blocked user content"
            cell.userProfileImage.image = #imageLiteral(resourceName: "logo-1")
            
            let unblockButton = MGSwipeButton(title: "Unblock", backgroundColor: UIColor.blue)
            {
                (sender: MGSwipeTableCell!) in

                let currentUser = PFUser.current()
                var blockedUsers = currentUser?.value(forKey: "blocked_users") as! [String]
                if let index = blockedUsers.index(of: currentEntry.createdBy!) {
                    blockedUsers.remove(at: index)
                }

                currentUser?["blocked_users"] = blockedUsers
                
                currentUser?.saveInBackground(block: {(succeeded:Bool, error:Error?) -> Void in
                    if succeeded {
                        var pfuser = PFUser.current()?.fetchInBackground(block: {(object, error) -> Void in
                            if (error != nil) {
                                print(error)
                            }
                            else {
                                
                                self.currentUser = User(pfobject: PFUser.current()!)
                                self.tableView.reloadData()
                            }
                        })
                    }
                    else {
                        print(error!)
                    }
                })
                
                return true
            }
            
            unblockButton.titleLabel?.font = UIFont(name: "DIN", size: 15)
            cell.rightButtons = [reportButton, unblockButton]
            cell.rightSwipeSettings.transition = .rotate3D
        }
        // Configure the cell...
        else {
            cell.entryLabel.text = currentEntry.text
            cell.userProfileImage.image = userImageDict[currentEntry.createdBy!]
            let blockButton = MGSwipeButton(title: "Block", backgroundColor: UIColor.blue)
            {
                (sender: MGSwipeTableCell!) in
            
                print("\(currentEntry.author!), \(currentEntry.number!)")
                let currentUser = PFUser.current()
                var blockedUsers = currentUser?.value(forKey: "blocked_users") as! [String]
                blockedUsers.append(currentEntry.createdBy!)
                currentUser?["blocked_users"] = blockedUsers
            
                currentUser?.saveInBackground(block: {(succeeded:Bool, error:Error?) -> Void in
                    if succeeded {
                        var pfuser = PFUser.current()?.fetchInBackground(block: {(object, error) -> Void in
                            if (error != nil) {
                                print(error)
                            }
                            else {
                                
                                self.currentUser = User(pfobject: PFUser.current()!)
                                self.tableView.reloadData()
                            }
                        })
                    }
                    else {
                        print(error!)
                    }
                })
            return true
            
            }
            blockButton.titleLabel?.font = UIFont(name: "DIN", size: 15)
            cell.rightButtons = [reportButton, blockButton]
            cell.rightSwipeSettings.transition = .rotate3D
        }
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
    
    func loadingModalIn () {
        
        effectView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(effectView!)
        
        self.view.addSubview(loadingModal)
        loadingModal.center = self.view.center
        loadingModal.center.y += 15
        loadingModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        loadingModal.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = UIBlurEffect(style: .light)
            self.loadingModal.alpha = 1
            self.loadingModal.transform =  CGAffineTransform.identity
        })
        
    }
    
    //Function to make the modal leave the screen
    func loadingModalOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView?.effect = nil
            self.loadingModal.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.loadingModal.alpha = 0
        }, completion: {(success: Bool) -> Void in
            self.loadingModal.removeFromSuperview()
        })
    }

}

