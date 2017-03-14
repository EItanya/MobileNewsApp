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

    @IBOutlet var storyCompletionControl: UISegmentedControl!
    
    //filters
    var applyFilters = 0
    
    //current checked filters
    var genre = [false, false, false, false]
    var wordCount = [false, false, false]
    var numPeople = [false, false, false]
    
    //index of genres
    let genreCategories : [String] = ["Horror", "Comedy", "Fiction", "Non-Fiction"]
    
    //unfinished stories
    var unfinishedStories = [Story]()
    var unfinishedFilteredStories = [Story]()
    
    //completedStories
    var completedStories = [Story]()
    var completedFilteredStories = [Story]()
    
    //stories to populate views
    var stories = [Story]()
    var filteredStories = [Story]()
    
    //var storiesStoryObject = [Story]()
    
    
    //table view of stories
    @IBOutlet var storyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Dynamic sizing of story cells
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.rowHeight = UITableViewAutomaticDimension
        storyTableView.estimatedRowHeight = 140
        
        //Custom font for segmented control object
        let attr = NSDictionary(object: UIFont(name: "DIN", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        storyCompletionControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Queries for stories and places it in its respective completed, unfinished, etc. arrays
//        let query = PFQuery(className: "Story")
//        query.getObjectInBackground(withId: "ssnrNOXJZD", block: { (story: PFObject?, error: Error?) -> Void in
//            if error != nil {
//                print("Error in retrieving storyobject")
//            }
//            else {
//                story?.setValue(true, forKey: "completed")
//                story?.saveInBackground()
//            }
//        })
        Story.getAllStories(completion: {(stories: [Story]?, Error) -> Void in
            let validStories = stories!.filter { $0.users.contains(PFUser.current()!.objectId!) == false }
            self.unfinishedStories = validStories.filter { $0.completed == false }
            self.unfinishedFilteredStories = self.unfinishedStories
            self.completedStories = (stories?.filter { $0.completed == true })!
            self.completedFilteredStories = self.completedStories
            if self.storyCompletionControl.selectedSegmentIndex == 0 {
                self.stories = self.completedStories
                self.filteredStories = self.completedFilteredStories
            }
            else {
                self.stories = self.unfinishedStories
                self.filteredStories = self.unfinishedFilteredStories
            }
            
            self.applyStoryFilters()
            
            self.storyTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action to take when story read/join segment control changed value
    @IBAction func storyTypeSegmentChosen(_ sender: UISegmentedControl) {
        //Switches to show completed stories
        if storyCompletionControl.selectedSegmentIndex == 0 {
            stories = completedStories
            filteredStories = completedFilteredStories
        }
        //Switches to show unfinished stories
        else {
            stories = unfinishedStories
            filteredStories = unfinishedFilteredStories
        }
        storyTableView.reloadData()
    }
    
    //Populates the filtered stories array which is used to fill in table view
    func applyStoryFilters() {
        //apply filters
        if applyFilters > 0 {
            filteredStories.removeAll()
            for (index, value) in genre.enumerated() {
                if value == true {
                    filteredStories.append(contentsOf: stories.filter({$0.genre! == genreCategories[index] }))
                }
            }
        }
        //no filters
        else {
            filteredStories = stories
        }
    }
}

//
//MARK: - Popover Delegate for story filters
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
        self.applyStoryFilters()
        storyTableView.reloadData()
    }
}

//
//MARK: - Filter Delegate to track actions inside the filter popover view
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
        if storyCompletionControl.selectedSegmentIndex == 0 {
            let cell = storyTableView.dequeueReusableCell(withIdentifier: "readStoryCell", for: indexPath) as! ReadStoryTableViewCell
            
            let currentStory = filteredStories[indexPath.row]
            cell.titleLabel.text = currentStory.title
            
            return cell
        }
        else {
        let cell = storyTableView.dequeueReusableCell(withIdentifier: "joinStoryCell", for: indexPath) as! HomeStoryTableViewCell
        
        let currentStory = filteredStories[indexPath.row]
        
        cell.titleLabel.text = currentStory.title
        cell.promptLabel.text = currentStory.prompt
        cell.genreLabel.text = currentStory.genre
        let currentUserId = currentStory.currentUser
        var peopleInLine = 0
        if currentUserId != "" {
            peopleInLine = currentStory.users.count - currentStory.users.index(of: currentUserId!)!
        }
        cell.peopleAheadLabel.text = "\(peopleInLine) people ahead"
        cell.turnCountLabel.text = "\(currentStory.currentEntry!)/\(currentStory.totalTurns!) turns"

        
        return cell
        }
    }
    
    //Shows the StoryJoinView Controller particular to the story cell clicked when joined
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if storyCompletionControl.selectedSegmentIndex == 0 {
            let storyboard: UIStoryboard = UIStoryboard(name: "CompletedStory", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReadStoryViewController") as! CompletedStoryTableViewController
            vc.story = filteredStories[indexPath.row]
            self.show(vc, sender: self)
        }
        else {
            let storyboard: UIStoryboard = UIStoryboard(name: "JoinStory", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "JoinStoryViewController") as! StoryJoinViewController
            vc.story = filteredStories[indexPath.row]
            self.show(vc, sender: self)
        }
    }
    
    // MARK: - Navigation
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
}
