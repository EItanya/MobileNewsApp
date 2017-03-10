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
    
    init(email: String, firstName: String, lastName: String, id: String, completedStories: [String]?, activeStories: [String]?, fb_id: String, fb_profile_picture: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.comletedStoryIds = completedStories
        self.activeStoryIds = activeStories
        self.fb_id = fb_id
        self.fb_profile_picture = fb_profile_picture
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
            let userObject: User?  = User(email: user.object(forKey: "username") as! String, firstName: user.object(forKey: "first_name") as! String, lastName: user.object(forKey: "last_name") as! String, id: user.objectId!, completedStories: user.object(forKey: "completed_stories") as? [String], activeStories: user.object(forKey: "active_stories") as? [String])
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
                userArray = User.convertToUsers(userObjects: objects!)
                
            }
            
            
            if completion != nil {
                completion!(userArray, returnError)
            }
            
            
        })
    }
    
    
}
