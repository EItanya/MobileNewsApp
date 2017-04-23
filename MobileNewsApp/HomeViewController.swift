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
    
    //table view of stories
    @IBOutlet var storyTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
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
        
        self.storyTableView.addSubview(self.refreshControl)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStories(completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStories(completion: ((_ refreshControl: UIRefreshControl) -> Void)?) {
        Story.getAllStories(completion: {(stories: [Story]?, Error) -> Void in
            let validStories = stories!.filter { $0.users.contains(PFUser.current()!.objectId!) == false }
            self.unfinishedStories = validStories.filter { $0.completed == false }
            self.unfinishedFilteredStories = self.unfinishedStories
            self.completedStories = (stories?.filter { $0.completed == true })!
            self.completedFilteredStories = self.completedStories
            if self.storyCompletionControl.selectedSegmentIndex == 1 {
                self.stories = self.completedStories
                self.filteredStories = self.completedFilteredStories
            }
            else {
                self.stories = self.unfinishedStories
                self.filteredStories = self.unfinishedFilteredStories
            }
            
            self.applyStoryFilters()
            self.storyTableView.reloadData()
            
            completion?(self.refreshControl)
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getStories(completion: { (refreshControl) in
            refreshControl.endRefreshing()
        })
    }
    
    //Action to take when story read/join segment control changed value
    @IBAction func storyTypeSegmentChosen(_ sender: UISegmentedControl) {
        //Switches to show completed stories
        if storyCompletionControl.selectedSegmentIndex == 1 {
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
            var genreStories = [Story]()
            for (index, value) in genre.enumerated() {
                if value == true {
                    genreStories.append(contentsOf: stories.filter({$0.genre! == genreCategories[index] }))
                }
            }
//            var genreStories = [Story]()
//            for (index, value) in genre.enumerated() {
//                if value == true {
//                    genreStories.append(contentsOf: stories.filter({$0.genre! == genreCategories[index] }))
//                }
//            }
            
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
        if storyCompletionControl.selectedSegmentIndex == 1 {
            let cell = storyTableView.dequeueReusableCell(withIdentifier: "readStoryCell", for: indexPath) as! ReadStoryTableViewCell
            
            let currentStory = filteredStories[indexPath.row]
            cell.titleLabel.text = currentStory.title
            cell.numTurnsLabel.text = "\(currentStory.totalTurns!) turns"
            if currentStory.users.count == 1 {
                cell.numWritersLabel.text = "\(currentStory.users.count) writer"
            }
            else {
                cell.numWritersLabel.text = "\(currentStory.users.count) writers"
            }
            cell.promptLabel.text = currentStory.prompt
            
            return cell
        }
        else {
        let cell = storyTableView.dequeueReusableCell(withIdentifier: "joinStoryCell", for: indexPath) as! HomeStoryTableViewCell
        
        let currentStory = filteredStories[indexPath.row]
        
        cell.titleLabel.text = currentStory.title
        cell.promptLabel.text = currentStory.prompt
        cell.spotsLabel.text = "\(currentStory.participants - currentStory.users.count) spots remaining"
        let currentUserId = currentStory.currentUser
        var peopleInLine = 0
        if currentUserId != "" {
            peopleInLine = currentStory.users.count - currentStory.users.index(of: currentUserId!)!
        }
        if peopleInLine == 1 {
                cell.peopleAheadLabel.text = "\(peopleInLine) person ahead"
        }
        else {
            cell.peopleAheadLabel.text = "\(peopleInLine) people ahead"
        }
        cell.turnCountLabel.text = "\(currentStory.currentEntry!)/\(currentStory.totalTurns!) turns"

        
        return cell
        }
    }
    
    //Shows the StoryJoinView Controller particular to the story cell clicked when joined
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStory = filteredStories[indexPath.row]
        if storyCompletionControl.selectedSegmentIndex == 1 {
            let storyboard: UIStoryboard = UIStoryboard(name: "CompletedStory", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReadStoryViewController") as! CompletedStoryTableViewController
            vc.story = currentStory
            let myGroup = DispatchGroup()
            let session = URLSession(configuration: .default)
            var userImageDict: [String: UIImage] = [:]

            for user in currentStory.users {
                myGroup.enter()
                let query = PFUser.query()
                query?.getObjectInBackground(withId: user, block: { (currentUser, error) in
                    if error != nil {
                        print("Problem querying for user")
                    }
                    else {
                        let url = currentUser!["fb_profile_picture"] as? String
                        myGroup.enter()
                        let pictureUrl = URL(string: url!)
                        let downloadPicTask = session.dataTask(with: pictureUrl!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print ("Error in downloading image")
                            }
                            else {
                                if let res = response as? HTTPURLResponse {
                                    print("Downloaded profile picture with response code \(res.statusCode)")
                                    if let imageData = data {
                                        userImageDict[user] = UIImage(data: imageData)
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

            myGroup.notify(queue: .main) {
                vc.userImageDict = userImageDict
                self.show(vc, sender: self)
            }
        }
        else {
            let storyboard: UIStoryboard = UIStoryboard(name: "JoinStory", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "JoinStoryViewController") as! StoryJoinViewController
            vc.story = currentStory
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
