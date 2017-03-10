

import UIKit
import Parse
import QuartzCore

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    var blurredHeaderImageView:UIImageView?
    
    @IBOutlet weak var turnSign: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileControl: UISegmentedControl!
    
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
    
    var storiesStoryObject = [Story]()
    var isMyTurn = false
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        ///
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 140
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        // Header - Image
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)

        let user = PFUser.current()
        let id = user?.objectId
        userId = id!
        //        if user != nil
        //        {
        //            let userId = user!.objectId
        //            id = userId!
        //            let index = id.index(id.startIndex, offsetBy: 9)
        //            id.substring(from: index)
        //
        //        }
        print("my id is \(id)")
        print("my userId is \(userId)")
        
//        Story.getUserStories(userId: id!) {
//            (stories:[Story]?, Error) in
//            //print("how about here id is \(id!)")
//
//            self.unfinishedStories = stories!.filter { $0.completed == false }
//            self.completedStories = stories!.filter { $0.completed == true }
//            self.stories = self.unfinishedStories
//            self.profileTableView.reloadData()
//        }
        
        Story.getUserStoriesArray { (stories, Error) in
            
            self.unfinishedStories = stories!.filter { $0.completed == false }
            self.completedStories = stories!.filter { $0.completed == true }
            self.stories = self.unfinishedStories + self.completedStories
            self.profileTableView.reloadData()
        }

        
        
        header.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        PFUser.logOutInBackground()
    }
    

    @IBAction func profileTabSwitch(_ sender: UISegmentedControl) {
        if profileControl.selectedSegmentIndex == 0 {
            stories = completedStories
        }
        else {
            stories = unfinishedStories
        }
        profileTableView.reloadData()
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in profileTableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ profileTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of stories: \(stories.count)")
        return stories.count
    }
    
    func tableView(_ profileTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.titleLabel.text = stories[indexPath.row].title
        cell.genreLabel.text = stories[indexPath.row].genre
        cell.promptLabel.text = stories[indexPath.row].prompt
        if(stories[indexPath.row].currentUser! == userId)
        {
            cell.imgMyTurn.image = #imageLiteral(resourceName: "check_mark")
        }
        else
        {
            cell.imgMyTurn.image = #imageLiteral(resourceName: "x_mark")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Story") as! StoryViewController
        vc.story = stories[indexPath.row]
        
        self.show(vc, sender: self)
    }

}
