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
    
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    
    @IBOutlet weak var loadingModal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        
        titleLabel.text = story?.title
        authorLabel.text = story?.author
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: story!.url) as URL!
        content.contentTitle = "\(story!.title!)"
        content.contentDescription = "Add a caption"
        content.imageURL = NSURL(string: "https://s3-us-west-2.amazonaws.com/mobile-news-app/logonew_720.png") as URL!
        
        let fbkShareBtn: FBSDKShareButton = FBSDKShareButton()
        fbkShareBtn.shareContent = content
        fbkShareBtn.frame = CGRect(x: headerView.center.x, y: headerView.center.y, width: 100, height: 25)
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
        story?.getEntries(completion: {(error: Error?) -> Void in
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
        
        // Configure the cell...
        cell.entryLabel.text = currentEntry.text
        cell.userProfileImage.image = userImageDict[currentEntry.createdBy!]
        let reportButton = MGSwipeButton(title: "Report", backgroundColor: UIColor.red)
        {
            (sender: MGSwipeTableCell!) in
            
            print("\(currentEntry.author!), \(currentEntry.number!)")
            return true
            
        }
        reportButton.titleLabel?.font = UIFont(name: "DIN", size: 15)
        cell.rightButtons = [reportButton]
        cell.rightSwipeSettings.transition = .rotate3D
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
