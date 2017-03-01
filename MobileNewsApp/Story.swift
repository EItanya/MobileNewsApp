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
    
    var createdBy:String?
    var title:String?
    var genre:String?
    var completed: Bool = false
    var prompt:String?
    var firstEntry: Entry? = nil
    var previousEntry: Entry? = nil
    var wordCount: Int?
    var id :String? = nil
    var timeLimit : TimeInterval?
    var participants: Int = 5
    var totalTurns : Int?
    var users = [String]()
    var entryIds = [String]()
    var entries : [Entry]?
    
    static var listOfStoryItems = ["title", "genre", "prompt", "participants", "created_by", "time_limit", "max_word_count", "completed", "first_entry", "previous_entry", "total_turns", "entries", "entry_ids"]
    
    
    
    init(creator createdBy: String, title:String, genre: String, prompt: String, wordCount: Int, timeLimit: TimeInterval, participants: Int, totalTurns: Int ) {
        self.createdBy = createdBy
        self.title = title
        self.genre = genre
        self.prompt = prompt
        self.wordCount = wordCount
        self.timeLimit = timeLimit
        self.participants = participants
        self.totalTurns  = totalTurns
        self.users.append(createdBy)
    }

    //Function to create a new story in the DB
    //This function works
    func createNewStory(completion: ((_ story: Story?, _ error: Error?) -> Void)?) {
        let storyDict : [String: Any] = [
            "genre" : self.genre!,
            "title" : self.title!,
            "prompt": self.prompt!,
            "created_by": self.createdBy!,
            "participants": self.participants,
            "time_limit": self.timeLimit!,
            "max_word_count": self.wordCount!,
            "completed": self.completed,
            "total_turns": self.totalTurns!,
            "users" : self.users
        ]
        
        let entryDict : [String: Any] = [
            "text": self.firstEntry!.text!,
            "created_by": self.firstEntry!.createdBy!
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
                print(response ?? "")
                //Code to segue
            }
            completion!(returnStory, returnError)
        })
    }
    
    //Function to updateStory in DB
    func updateStory() {
        
    }
    
    //Function to update one local story
    func updateLocalStory() {
        
    }
    
    //Function to get all stories
    static func getAllStories(completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var storyArray : [Story]?
            if error != nil {
                print("Failed to query db")
                returnError = error
            } else {
                print("Successfully retrieved stories")
                storyArray = convertToStories(stories: objects!)
                for story in storyArray! {
                    print(story)
                }
                
            }
            completion!(storyArray, returnError)
        })
    }
    
    //Function to get all user stories, bool for completed
    static func getUserStories(userId: String, completion:  ((_ stories: [Story]?, _ error: Error?) -> Void)?) {
        let query = PFQuery(className: "Story")
        query.whereKey("id", equalTo: userId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
            var returnError: Error? = nil
            var storyArray : [Story]?
            if error != nil {
                print("Failed to query db")
                returnError = error
            } else {
                print("Successfully retrieved stories")
                storyArray = convertToStories(stories: objects!)
                for story in storyArray! {
                    print(story)
                }
                
            }
            completion!(storyArray, returnError)
        })
    }
    
    //Function to convert a bunch of parse objects into story objects for app to use
    private static func convertToStories(stories: [PFObject]) -> [Story] {
        var storyArray = [Story]()
        for story in stories {
            storyArray.append(
                Story(creator: story["created_by"] as! String,
                      title: story["title"] as! String,
                      genre: story["genre"] as! String,
                      prompt: story["prompt"] as! String,
                      wordCount: story["max_word_count"] as! Int,
                      timeLimit: story["time_limit"] as! TimeInterval,
                      participants: story["participants"] as! Int,
                      totalTurns: story["total_turns"] as! Int
                )
            )
        }
        return storyArray
    }
}



class Entry {
    var text: String?
    var createdBy: String?
    init(createdBy: String, text: String) {
        self.text = text
        self.createdBy = createdBy
    }
}



