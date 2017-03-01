//
//  HomeViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/27/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    //filters
    var applyFilters = 0
    
    //current checked filters
    var genre = [false, false, false, false]
    var wordCount = [false, false, false]
    var numPeople = [false, false, false]
    
    //index of genres
    let genreCategories : [String] = ["Horror", "Comedy", "Fiction", "Non-Fiction"]
    
    var stories = [PFObject]()
    var filteredStories = [PFObject]()
    
    
    //table view of stories
    @IBOutlet var storyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storyTableView.delegate = self
        storyTableView.dataSource = self
        
        storyTableView.rowHeight = UITableViewAutomaticDimension
        storyTableView.estimatedRowHeight = 140
        
        let query = PFQuery(className: "Story")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                
                self.stories = objects!
                self.filteredStories = objects!
                print("Successfully retrieved stories")
                print(self.stories.count)
                for story in self.stories {
                    print(story.objectId)
                    let arr = ["title", "genre", "prompt"]
                    for item in story.dictionaryWithValues(forKeys: arr) {
                        print(item.value)
                    }
                }
            } else {
                print("Failed to query db")
            }
            self.storyTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//MARK: - Popover Delegate
//
extension HomeViewController: UIPopoverPresentationControllerDelegate {
    @IBAction func filterBtnClk(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "filter") as! CollapsibleTableViewController
        
        //sets chosen filter values for filterPopupController
        vc.genreValues = genre
        vc.wordCountValues = wordCount
        vc.numContValues = numPeople
        
        vc.modalPresentationStyle = .popover
        vc.delegate = self
        let popover = vc.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .up
        popover.sourceView = sender as UIView
        popover.sourceRect = sender.bounds
        
        present(vc, animated: false, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if applyFilters > 0 {
            filteredStories.removeAll()
            for (index, value) in genre.enumerated() {
                if value == true {
                    filteredStories.append(contentsOf: stories.filter({$0.value(forKey: "genre") as! String == genreCategories[index]}))
                }
            }
        }
        else {
            filteredStories = stories
        }
        storyTableView.reloadData()
    }
}

//
//MARK: - Filter Delegate
//
extension HomeViewController: FilterTableViewDelegate {
    func checkboxValueChanged2(value: Int, section: Int, row: Int) {
        
        //checks to see if filters are applied
        if value == 1 {
            applyFilters += 1
        }
            
        else {
            applyFilters -= 1
        }
        
        //updates filter values
        if section == 0 {
            self.genre[row] = value.toBool()!
        }
        else if section == 1 {
            self.wordCount[row] = value.toBool()!
        }
        else {
            self.numPeople[row] = value.toBool()!
        }
        
//        filteredStories.removeAll()
//        
//        for (index, value) in genre.enumerated() {
//            if value == true {
//                filteredStories = stories.filter({$0.value(forKey: "genre") as! String == genreCategories[index]})
//            }
//        }
//        
//        storyTableView.reloadData()
//        if applyFilters > 0 {
//            filteredStories.removeAll()
//            for (index, value) in genre.enumerated() {
//                if value == true {
//                    filteredStories.append(contentsOf: stories.filter({$0.value(forKey: "genre") as! String == genreCategories[index]}))
//                }
//            }
//        }
//        else {
//            filteredStories = stories
//        }
//        storyTableView.reloadData()
    }
}

//
//MARK: - Story List TableView
//
extension HomeViewController:  UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in storyTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ storyTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStories.count
    }
    
    func tableView(_ storyTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = storyTableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! HomeStoryTableViewCell
        cell.titleLabel.text = filteredStories[indexPath.row].value(forKey: "title") as? String
        cell.promptLabel.text = filteredStories[indexPath.row].value(forKey: "prompt") as? String
        cell.genreLabel.text = filteredStories[indexPath.row].value(forKey: "genre") as? String

        
        return cell
    }
    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
}
