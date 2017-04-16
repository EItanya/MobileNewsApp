

import UIKit
import Parse
import QuartzCore
import AVFoundation
import BBBadgeBarButtonItem

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
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notificationImage: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: LogoutButton!

    
    
    //current checked filters
    //var genre = [false, false, false, false]
    var wordCount = [false, false, false]
    var numPeople = [false, false, false]
    
    //index of genres
    //let genreCategories : [String] = ["Horror", "Comedy", "Fiction", "Non-Fiction"]
    
    //unfinished stories
    var unfinishedStories = [Story]()
    var unfinishedFilteredStories = [Story]()
    
    //completedStories
    var completedStories = [Story]()
    
    //stories to populate views
    var stories = [Story]()
    
    var storiesStoryObject = [Story]()
    var isMyTurn = false
    var userId = String()
    
    var entryArray = [Entry]()
    var userImageDict: [String: UIImage] = [:]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 50
        logoutButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)

        
        Story.getUserStoriesArray { (stories, Error) in
            self.unfinishedStories = stories!.filter { $0.completed == false }
            self.completedStories = stories!.filter { $0.completed == true }
            
            if self.profileControl.selectedSegmentIndex == 0 {
                print("All is selected in viewDidLoad")
                self.stories = self.completedStories + self.unfinishedStories
            }
            else if self.profileControl.selectedSegmentIndex == 1 {
                print("Incomplete is selected in viewDidLoad")

                self.stories = self.unfinishedStories
            }
            else
            {
                print("Completed is selected in viewDidLoad")
                self.stories = self.completedStories
            }
            self.profileTableView.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        Story.getUserStoriesArray { (stories, Error) in
            self.unfinishedStories = stories!.filter { $0.completed == false }
            self.completedStories = stories!.filter { $0.completed == true }
            
            if self.profileControl.selectedSegmentIndex == 0 {
                print("All is selected in viewDidLoad")
                self.stories = self.completedStories + self.unfinishedStories
            }
            else if self.profileControl.selectedSegmentIndex == 1 {
                print("Incomplete is selected in viewDidLoad")
                
                self.stories = self.unfinishedStories
            }
            else
            {
                print("Completed is selected in viewDidLoad")
                self.stories = self.completedStories
            }
            self.profileTableView.reloadData()
        }

        
        let user = PFUser.current()
        let id = user?.objectId
        userId = id!
        
        print("my id is \(id)")
        print("my userId is \(userId)")
        
        
        let profileName = (user?.object(forKey: "first_name") as! String) + " " + (user?.object(forKey: "last_name") as! String)
        self.profileName.text = profileName
        let invites = [Invite]()
        let numInvites = invites.count
        print("This is the number of invites i have \(numInvites)")
        
        let session = URLSession(configuration: .default)
        let url = user!["fb_profile_picture"] as? String
        print("WHAT IS MY URL RIGHT HERE \(url)")
        if url != nil
        {
            let pictureUrl = URL(string: url!)
        
            let downloadPicTask = session.dataTask(with: pictureUrl!, completionHandler: { (data, response, error) in
                if error != nil {
                    print ("Error in downloading image")
                }
                else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded profile picture with response code \(res.statusCode)")
                        if let imageData = data {
                            self.profileImage.image = UIImage(data: imageData)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.image = UIImage(data: imageData)
                        print("image refreshed")
                    }
                }
            })
            downloadPicTask.resume()
        }
        else
        {
            self.profileImage.image = #imageLiteral(resourceName: "default-avatar")
        }
        
        let image = UIImage(named: "Invite")
        
        let button = UIButton(type: .custom)
        button.tag = 5
        button.frame = CGRect(x:0, y:0, width:30, height:30)
        button.addTarget(self, action:#selector(manageInviteSegue), for: .touchUpInside)
        button.setBackgroundImage(image, for: .normal)
        
        let rightButton = BBBadgeBarButtonItem(customUIButton: button)
        rightButton?.badgeValue = "\(numInvites)"
        rightButton?.badgeOriginX = 20
        rightButton?.badgeOriginY = -5
        navigationItem.rightBarButtonItem = rightButton
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        let user = PFUser.current()
        let id = user?.objectId
        userId = id!

        print("my id is \(id)")
        print("my userId is \(userId)")
        

        let profileName = (user?.object(forKey: "first_name") as! String) + " " + (user?.object(forKey: "last_name") as! String)
        self.profileName.text = profileName
        let invites = [Invite]()
        let numInvites = invites.count
        print("This is the number of invites i have \(numInvites)")

        let session = URLSession(configuration: .default)
        let url = user!["fb_profile_picture"] as? String
        if url != nil
        {
            let pictureUrl = URL(string: url!)
            
            let downloadPicTask = session.dataTask(with: pictureUrl!, completionHandler: { (data, response, error) in
                if error != nil {
                    print ("Error in downloading image")
                }
                else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded profile picture with response code \(res.statusCode)")
                        if let imageData = data {
                            self.profileImage.image = UIImage(data: imageData)
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
                
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.image = UIImage(data: imageData)
                        print("image refreshed")
                    }
                }
            })
            downloadPicTask.resume()
        }
        else
        {
            self.profileImage.image = #imageLiteral(resourceName: "default-avatar")
        }
        
        let image = UIImage(named: "Invite")

        let button = UIButton(type: .custom)
        button.tag = 5
        button.frame = CGRect(x:0, y:0, width:30, height:30)
        button.addTarget(self, action:#selector(manageInviteSegue), for: .touchUpInside)
        button.setBackgroundImage(image, for: .normal)
        
        let rightButton = BBBadgeBarButtonItem(customUIButton: button)
        rightButton?.badgeValue = "\(numInvites)"
        rightButton?.badgeOriginX = 20
        rightButton?.badgeOriginY = -5
        navigationItem.rightBarButtonItem = rightButton
        
    }
    

    
    ////////////////
    


    
    ///////////////
    
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        //self.performSegue(withIdentifier: "logoutSegue", sender: self)
        PFUser.logOutInBackground()
    }

    func manageInviteSegue(_ sender: UIButton)
    {
        //self.performSegue(withIdentifier: "logoutSegue", sender: self)
        self.performSegue(withIdentifier: "manageInvitesSegue", sender: self)
    }
    
    
    @IBAction func manageInvite(_ sender: Any) {
        
        self.performSegue(withIdentifier: "manageInvitesSegue", sender: self)
    }


    // Switching between stories all, completed, incomplete

    @IBAction func profileTabSwitch(_ sender: Any) {
        if profileControl.selectedSegmentIndex == 0 {
            print("did change it to all")
            stories = completedStories + unfinishedStories
        }
        else if profileControl.selectedSegmentIndex == 1
        {
            print("did change it to incomplete")
            stories = unfinishedStories
        }
        else
        {
            print("did change it to completed")
            
            stories = completedStories
        }
        profileTableView.reloadData()
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
        //cell.genreLabel.text = stories[indexPath.row].genre
        //cell.promptLabel.text = stories[indexPath.row].prompt
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
