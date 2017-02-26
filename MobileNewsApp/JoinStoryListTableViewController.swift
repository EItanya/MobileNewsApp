//
//  JoinStoryListTableViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/24/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class JoinStoryListTableViewController: UITableViewController {
    
    var objects = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.layer.cornerRadius = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Story")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                
                self.objects = objects!
                print("Successfully retrieved stories")
                print(objects?.count)
                for object in objects! {
                    print(object.objectId)
                    let arr = ["title", "genre", "prompt"]
                    for item in object.dictionaryWithValues(forKeys: arr) {
                        print(item.value)
                    }
                }
            } else {
                print("Failed to query db")
            }
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> JoinStoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! JoinStoryTableViewCell

        // Configure the cell...
        cell.titleLabel.text = objects[indexPath.row].value(forKey: "title") as! String
        cell.promptLabel.text = objects[indexPath.row].value(forKey: "prompt") as! String
        cell.genreLabel.text = objects[indexPath.row].value(forKey: "genre") as! String

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
