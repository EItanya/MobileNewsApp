

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
    
    var entryArray = [Entry]()
    var userImageDict: [String: UIImage] = [:]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        ///
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.estimatedRowHeight = 140
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        // Header - Image
//        headerImageView = UIImageView(frame: header.bounds)
//        headerImageView?.image = UIImage(named: "header_bg")
//        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        //header.insertSubview(headerImageView, belowSubview: headerLabel)

        let user = PFUser.current()
        let id = user?.objectId
        userId = id!

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

        let profileName = (user?.object(forKey: "first_name") as! String) + " " + (user?.object(forKey: "last_name") as! String)
        self.profileName.text = profileName
        let invites = [Invite]()
        let numInvites = invites.count
        print("This is the number of invites i have \(numInvites)")
        //self.notificationCount.text = String(numInvites)
        //self.notificationImage.setImage(#imageLiteral(resourceName: "Invite"), for: UIControlState.normal)
        //self.notificationImage.setTitle("", for: UIControlState.normal)
        
        //let img = userImageDict[user]
        
        //let image = (user?.object(forKey: "fb_profile_picture") as! UIImage)
        //print("This is my link to the picture: \(image)")
        //self.profileImage.image = image
        
        //let imageString = (user?.object(forKey: "fb_profile_picture"))

        
       // let url = URL(string: image.imageString)
        let session = URLSession(configuration: .default)
        let url = user!["fb_profile_picture"] as? String
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
        
        
//        var image = UIImage(named: "Invites")
//        var button = UIButton(type: .custom)
//        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image!.size.width), height: CGFloat((image?.size.height)!))
//        button.addTarget(self, action: #selector(self.buttonPress), for: .touchDown)
//        button.setBackgroundImage(image, for: .normal)
//        // Make BarButton Item
//        var navLeftButton = UIBarButtonItem(customView: button)
//        navigationItem.leftBarButtonItem = navLeftButton
//        navigationItem.leftBarButtonItem?.badgeValue = "1"
//
//        
//        let navRightButton = BBBadgeBarButtonItem(customUIButton: notification)
//        //let button = UIButton(type: .custom)
//        //button.setAttributedTitle(notificationImage.attributedString(), for: .Normal)
//        let notification = BBBadgeBarButtonItem(customUIButton: notificationImage)
//        notificationImage.frame = CGRect(x:0, y:0, width:44, height:44)
//        //notification?.badgeValue = "\(numInvites)"
//        notification?.badgeValue = "1"
//
//        //notification?.shouldHideBadgeAtZero = false
//        //notification?.shouldAnimateBadge = true
//        notification?.badgeOriginX = 5
//        notification?.badgeOriginY = 5
//        self.navigationItem.rightBarButtonItem = notification


//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        imageView.image = UIImage(data: data!)
        
        //header.clipsToBounds = true
    }
    


    
    
    
    
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


    
    @IBAction func manageInvite(_ sender: Any) {
        self.performSegue(withIdentifier: "manageInvitesSegue", sender: self)
    }


    @IBAction func profileTabSwitch(_ sender: UISegmentedControl) {
        if profileControl.selectedSegmentIndex == 0 {
            stories = completedStories + unfinishedStories
        }
        else if profileControl.selectedSegmentIndex == 1
        {
            stories = unfinishedStories
        }
        else
        {
            stories = completedStories
        }
        profileTableView.reloadData()
    }
    

    
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let offset = scrollView.contentOffset.y
//        var avatarTransform = CATransform3DIdentity
//        var headerTransform = CATransform3DIdentity
//        
//        // PULL DOWN -----------------
//        
//        if offset < 0 {
//            
//            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
//            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
//            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
//            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
//            
//            header.layer.transform = headerTransform
//        }
//            
//            // SCROLL UP/DOWN ------------
//            
//        else {
//            
//            // Header -----------
//            
//            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
//            
//            //  ------------ Label
//            
//            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
//            headerLabel.layer.transform = labelTransform
//            
//            //  ------------ Blur
//            
//            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
//            
//            // Avatar -----------
//            
//            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
//            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
//            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
//            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
//            
//            if offset <= offset_HeaderStop {
//                
//                if avatarImage.layer.zPosition < header.layer.zPosition{
//                    header.layer.zPosition = 0
//                }
//                
//            }else {
//                if avatarImage.layer.zPosition >= header.layer.zPosition{
//                    header.layer.zPosition = 2
//                }
//            }
//        }
//        
//        // Apply Transformations
//        
//        header.layer.transform = headerTransform
//        avatarImage.layer.transform = avatarTransform
//    }
    
    
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

//extension ProfileViewController {
//    func setupNotification() {
//        let button = UIButton(type: .custom)
//        let notificationImage = "Invite"
//        let image = UIImage(named: notificationImage)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        view.addSubview(imageView)
//
//        //button.setAttributedTitle(imageView.attributedString(), for: .Normal)
//        button.addTarget(self, action: Selector(("buttonClicked")), for: UIControlEvents.touchUpInside)
//        let notification = BBBadgeBarButtonItem(customUIButton: button)
//        button.frame = CGRect(x:0, y:0, width:44, height:44)
//        notification?.badgeValue = num.
//        
//        self.navigationItem.rightBarButtonItem = notification
//        
//    }
//}
