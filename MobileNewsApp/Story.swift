//
//  Story.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/26/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import Foundation
import Parse

class Story {
    
    //ID of User
    var createdBy:String?
    //First and Last name of User, for convenience
    var author:String?
    var title:String?
    var genre:String?
    var completed: Bool = false
    var prompt:String?
    var firstEntry: String? = nil
    var previousEntry: String? = nil
    var totalWordCount: Int?
    var maxWordCount: Int?
    var id :String? = nil
    var timeLimit : Double?
    var participants: Int = 5
    var currentEntry: Int?
    var totalTurns : Int?
    //Nil at first to setup initial current_user TODO add this to join logic
    var currentUser: String? = nil
    //An Array of users involved in this story
    var users = [String]()
    //an Array of Entry ids for DB
    var entryIds = [String]()
    //List of entries for after they are fetched
    var entries : [Entry]?
    
    static var listOfStoryItems = ["title", "genre", "prompt", "participants", "created_by", "time_limit", "max_word_count", "completed", "first_entry", "previous_entry", "total_turns", "entries", "entry_ids"]
    
    
    
    init(creator createdBy: String, title:String, genre: String, prompt: String, maxWordCount: Int, timeLimit: Double, participants: Int, totalTurns: Int, currentEntry: Int) {
        self.createdBy = createdBy
        self.title = title
        self.genre = genre
        self.prompt = prompt
        self.maxWordCount = maxWordCount
        self.timeLimit = timeLimit
        self.participants = participants
        self.totalTurns  = totalTurns
        self.currentEntry = currentEntry
        self.users.append(createdBy)
    }
    

    //Function to create a new story in the DB
    //This function works
    func createNewStory(entry: Entry, completion: ((_ story: Story?, _ error: Error?) -> Void)?) {
        let storyDict : [String: Any] = [
            "genre" : self.genre!,
            "title" : self.title!,
            "prompt": self.prompt!,
            "created_by": self.createdBy!,
            "participants": self.participants,
            "time_limit": self.timeLimit!,
            "max_word_count": self.maxWordCount!,
            "completed": self.completed,
            "total_turns": self.totalTurns!,
            "users" : self.users,
            "current_entry": 1,
            "current_user": "",
            "total_word_count": self.totalWordCount!,
            "author": self.author ?? "unknown"
        ]
        
        let entryDict : [String: Any] = [
            "text": entry.text!,
            "created_by": entry.createdBy!,
            "number": entry.number ?? 1
        ]
        
        //Possible change to cloud code to do all in one call
        //The response is the newly created story object, just in case we need it for something
        
        
        PFCloud.callFunction(inBackground: "createStory", withParameters: ["entry": entryDict, "story": storyDict], block: {
            (response: Any?, error: Error?) -> Void in
            //Edit later to include message about server issues.
            let returnError : Error? = nil
            let returnStory : Story? = nil
            if error != nil {
                print("Error saving data to DB:", error ?? "")
                
            } else {
//                let storyArray : [Story] = convertToStories(stories: [response! as! PFObject])
//                returnStory = storyArray[0]
                let user = PFUser.current()
                var activeArray : [String] = user?.object(forKey: "active_stories") as! [String]
                activeArray.append(response as! String)
                user?.setObject(activeArray, forKey: "active_stories")
                user?.saveInBackground()
                //Code to segue
            }
            completion!(returnStory, returnError)
        })
    }
    
    //Function to updateStory in DB
    func updateStoryAfterTurn(entry: Entry, completion: ((_ error: Error?) -> Void)?) {

        
        let entryDict : [String: Any] = [
            "text": entry.text!,
            "created_by": entry.createdBy!,
            "number": entry.number ?? 1
        ]
        
        PFCloud.callFunction(inBackground: "updateStoryWithEntry", withParameters: ["entry": entryDict, "storyId": self.id!], block: {
            (response: Any?, error: Error?) -> Void in
            //Edit later to include message about server issues.
            let returnError : Error? = nil
            if error != nil {
                print("Error saving data to DB:", error ?? "")
                
            } else {
                print(response ?? "")
                //Code to segue
            }
            completion!(returnError)
        })
    }
    
    //Function to update current local story
    func updateLocalStory() {
        
    }
    
    //Add a new user to the story
    func addUser(completion: ((_ error: Error?) -> Void)?) {
        let user = PFUser.current()
        let query = PFQuery(className: "Story")
        var returnError : Error? = nil
        query.getObjectInBackground(withId: self.id!, block: {(story: PFObject?, error: Error?) -> Void in
            if error == nil && story != nil {
                print(story ?? "")
                var users : [String] = story?.object(forKey: "users") as! [String]
                let currentUser: String = story?.object(forKey: "current_user") as! String
                if users.count == 1 && currentUser == "" {
                    //Logic if this is the second user being added
//                    story?.setObject(user?.objectId! as Any, forKey: "current_user")
                    story?.setValue(user?.objectId!, forKey: "current_user")
                    print(self)
                    self.currentUser = user?.objectId!
                }

                
                users.append((user?.objectId)!)
                story?.setObject(users, forKey: "users")
                story?.saveInBackground()
                
                //Code to add story to users_active stories
                var activeArray : [String] = user?.object(forKey: "active_stories") as! [String]
                activeArray.append(self.id! as String)
                user?.setObject(activeArray, forKey: "active_stories")
                user?.saveInBackground()
                
            } else {
                print(error ?? "")
                returnError = error
            }
            completion!(returnError)
        })
        
    }
    
    //Function to get all users from story users Array
    func getUsers(completion: ((_ users: [User]?, _ error: Error? ) -> Void)?) {
        
        let query:PFQuery = PFUser.query()!
        query.whereKey("objectId", containedIn: self.users)

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
            completion!(userArray, returnError)
        })
        
        
    }
    
    //This function works
    func deleteStory(completion: ((_ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.getObjectInBackground(withId: self.id!, block: {(story: PFObject?, error: Error?) -> Void in
            var returnError: Error? = nil
            if error != nil
            {
                print("could not retrieve story from DB")
                returnError = error!
            }
            else
            {
                story?.deleteInBackground()
            }
            completion!(returnError)
        })
    }
    
    func removeUser(user: String, completion: ((_ error: Error?) -> Void)?) {
        if self.currentUser == user
        {
            //Logic to move turn pointer to next person
            let index = self.users.index(of: user)
            //If item is last in list
            if index == self.users.count - 1
            {
                self.currentUser = self.users[0]
            }
        }
        
        self.users.remove(at: self.users.index(of: user)!)
        
        let userObj = PFUser.current()
        var activeStories = userObj?.object(forKey: "active_stories") as! [String]
        let index = activeStories.index(of: self.id!)
        activeStories.remove(at: index!)
        userObj?.setObject(activeStories, forKey: "active_stories")
        
        let query = PFQuery(className: "Story")
        query.getObjectInBackground(withId: self.id!, block: {(story: PFObject?, error: Error?) -> Void in
            let saveError: Error? = nil
            if error != nil {
                print("there was an error deleting you from the story")
            }
            else
            {
                
                story?.setObject(self.users, forKey: "users")
                story?.saveInBackground()
                userObj?.saveInBackground()
            }
            
            if let callback = completion! as ((Error?) -> Void)? {
                callback(saveError)
            }
        })
        
    }
    
    static func getStoryById() {
        
    }
    
    
    
    
    //Function to get all stories
    static func getAllStories(completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var storyArray : [Story]?
            if error != nil
            {
                print("Failed to query db")
                returnError = error
            }
            else
            {
                print("Successfully retrieved stories")
                storyArray = convertToStories(stories: objects!)
                
            }
            completion!(storyArray, returnError)
        })
    }
    
    //Function to get all user stories, bool for completed
    static func getUserStories(userId: String, completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.whereKey("created_by", equalTo: userId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var storyArray : [Story]?
            if error != nil
            {
                print("Failed to query db")
                returnError = error
            }
            else
            {
                print("Successfully retrieved stories")
                storyArray = convertToStories(stories: objects!)
                
            }
            completion!(storyArray, returnError)
        })
    }
    
    
    static func getUserCurrentStories(userId: String, completion:  ((_ current: Bool, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.whereKey("current_user", equalTo: userId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            let returnError: Error? = nil
            let current = false
                
            
            completion!(current, returnError)
        })
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
                storyArray = convertToStories(stories: objects!)
                //                for story in storyArray! {
                //                    print(story)
                //                }
            }
            completion!(storyArray, returnError)
        })
    }
    
    
    static func getUserStoriesArray(storyIds: [String], completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
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
                storyArray = convertToStories(stories: objects!)
//                for story in storyArray! {
//                    print(story)
//                }
            }
            completion!(storyArray, returnError)
        })
        
    }
    
    
    //Function to get all user stories, bool for completed
    func getEntries(completion:  ((_ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Entry")
        query.whereKey("objectId", containedIn: self.entryIds)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            if error != nil {
                print("Failed to query db")
                returnError = error
            } else {
                print("Successfully retrieved entries")
                for entry in objects! {
                    self.entries?.append(Entry(createdBy: entry.objectId!, text: entry.object(forKey: "text") as! String, number: entry.object(forKey: "number") as! Int))
                }
                
            }
            completion!(returnError)
        })
    }
    
    
    //Function to convert a bunch of parse objects into story objects for app to use
    static func convertToStories(stories: [PFObject]) -> [Story] {
        var storyArray = [Story]()
        var newStory: Story
        for story in stories {
            newStory = Story(creator: story["created_by"] as! String,
                                 title: story["title"] as! String,
                                 genre: story["genre"] as! String,
                                 prompt: story["prompt"] as! String,
                                 maxWordCount: story["max_word_count"] as! Int,
                                 timeLimit: story["time_limit"] as! Double,
                                 participants: story["participants"] as! Int,
                                 totalTurns: story["total_turns"] as! Int,
                                 currentEntry: story["current_entry"] as! Int
                            )
            newStory.firstEntry = story["first_entry"] as! String?
            newStory.previousEntry = story["previous_entry"] as! String?
            newStory.author = story["author"] as! String?
            newStory.id = story.objectId
            newStory.users = story["users"] as! [String]
            newStory.currentUser = story["current_user"] as! String?
            newStory.entryIds = story["entry_ids"] as! [String]
            newStory.totalWordCount = story["total_word_count"] as! Int?
            storyArray.append(newStory)
        }
        return storyArray
    }
}


//Trying out subclassing real quick again
//We can use it if we want
//class parseUser: PFUser {
//    
//    var first_name: String?
//    var last_name: String?
//    var fb_id: String?
//    var fb_profile_picture: String?
//    
//    override init() {
//        super.init()
//    }
//    
//    override init(className newClassName: String) {
//        super.init()
//    }
//    
//    init(email: String, password: String, firstName: String, lastName: String) {
//        super.init()
//        self.email = email
//        self.username = email
//        self.password = password
//        self.first_name = firstName
//        self.last_name = lastName
//    }
//    
//    init(email: String, password: String, firstName: String, lastName: String, facebookId: String, facebookProfilePic: String) {
//        super.init()
//        self.email = email
//        self.username = email
//        self.password = password
//        self.first_name = firstName
//        self.last_name = lastName
//        self.fb_id = facebookId
//        self.fb_profile_picture = facebookProfilePic
//    }
//    
//    
//    
//}



class Entry {
    var text: String?
    var createdBy: String?
    var number: Int?
    
    
    init(createdBy: String, text: String, number: Int) {
        self.text = text
        self.createdBy = createdBy
        self.number = number
    }

}



