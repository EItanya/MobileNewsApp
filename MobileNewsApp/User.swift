//
//  User.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/1/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import Foundation
import Parse

class User {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var comletedStoryIds: [String]?
    var completedStories: [Story]?
    var activeStories: [Story]?
    var activeStoryIds: [String]?
    var fb_id: String?
    var fb_profile_picture: String?
    var blockedUsers: [String]?
    
    

    
//    override init() {
//        super.init()
//        let user = PFUser.current()
//        self.email = user?.username
//        self.firstName = user?.object(forKey: "first_name") as! String?
//        self.lastName = user?.object(forKey: "last_name") as! String?
//        self.id = user?.objectId
//
//    }
    
    init(email: String, firstName: String, lastName: String, id: String, completedStories: [String]?, activeStories: [String]?) {
//        super.init()
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.comletedStoryIds = completedStories
        self.activeStoryIds = activeStories
    }
    
    init( firstName: String, lastName: String, id: String, completedStories: [String]?, activeStories: [String]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.comletedStoryIds = completedStories
        self.activeStoryIds = activeStories
    }
    
    init (pfobject: PFObject) {
        self.email = pfobject.value(forKey: "email") as! String?
        self.firstName = pfobject.value(forKey: "first_name") as! String?
        self.lastName = pfobject.value(forKey: "last_name") as! String?
        self.id = pfobject.objectId
        self.comletedStoryIds = pfobject.value(forKey: "completed_stories") as! [String]?
        self.activeStoryIds = pfobject.value(forKey: "active_stories") as! [String]?
        self.blockedUsers = pfobject.value(forKey: "blocked_users") as! [String]?
    }
    
    
    /**
     It returns completed and active stories from user object, only takes in completion block
     
     :param: completion is a completion block to be executed when the data has been retrieved
     
     :returns:   none
     */
    static func getUserStoriesArray(completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        let user = PFUser.current()
        var storyIds = [String]()
        if let completeStories = user?.object(forKey: "complete_stories") as! [String]? {
            storyIds += completeStories
        }
        if let activeStories = user?.object(forKey: "active_stories") as! [String]? {
            storyIds += activeStories
        }
        
        query.whereKey("objectId", containedIn: storyIds)
        //        query.whereKey("created_by", equalTo: userId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var storyArray : [Story]?
            if error != nil {
                print("Failed to query db")
                returnError = error
            } else {
                print("Successfully retrieved stories")
                storyArray = Story.convertToStories(stories: objects!)
                //                for story in storyArray! {
                //                    print(story)
                //                }
            }
            completion!(storyArray, returnError)
        })
    }
    
    
    static func convertToUsers(userObjects: [PFObject]) -> [User] {
        
        var users = [User]()
        for user in userObjects
        {
            //Code to set up basic user Object
            let userObject: User?  = User(firstName: user.object(forKey: "first_name") as! String, lastName: user.object(forKey: "last_name") as! String, id: user.objectId!, completedStories: user.object(forKey: "completed_stories") as? [String], activeStories: user.object(forKey: "active_stories") as? [String])
            if let fb_id = user.object(forKey: "fb_id") as? String
            {
                userObject?.fb_id = fb_id
                userObject?.fb_profile_picture = user.object(forKey: "fb_profile_picture") as? String
            }
            users.append(userObject!)

        }
        return users
        
        
    }
    
    static func getAllUsers(completion: ((_ users: [User]?, _ error: Error?) -> Void)?){
        let query:PFQuery = PFUser.query()!
//        let user = PFUser.current()
//        query.whereKey("objectId", notEqualTo: user?.objectId!)
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var userArray : [User]? = nil
            if error != nil
            {
                print("Failed to query db for Users")
                returnError = error
            }
            else
            {
                print("Successfully retrieved users")
//                for user in objects! {
//                    print(user.object(forKey: "first_name") as! String)
//                    print(user.object(forKey: "last_name") as! String)
//                    print(user.objectId!)
//                }
                userArray = User.convertToUsers(userObjects: objects!)
                
            }
            
            
            if completion != nil {
                completion!(userArray, returnError)
            }
            
            
        })
    }
    
    func unblockUser(user: String, completion: ((_ error: Error?) -> Void)?) {
        if let index = blockedUsers!.index(of: user) {
            blockedUsers!.remove(at: index)
        }
        
        PFUser.current()?["blocked_users"] = self.blockedUsers
        
        PFUser.current()?.saveInBackground(block: {(succeeded:Bool, error:Error?) -> Void in
            if succeeded {
                if completion != nil {
                    completion!(error)
                }
            }
            else {
                print(error!)
            }
        })
    }
    
    func blockUser(user: String, completion: ((_ error: Error?) -> Void)?) {
        self.blockedUsers!.append(user)
        
        PFUser.current()?["blocked_users"] = blockedUsers
        
        PFUser.current()?.saveInBackground(block: {(succeeded:Bool, error:Error?) -> Void in
            if succeeded {
                if completion != nil {
                    completion!(error)
                }
            }
            else {
                print(error!)
            }
        })
    }
    
}
