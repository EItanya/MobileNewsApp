//
//  User.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/1/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import Foundation
import Parse

class User : NSObject {
    var email: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var completedStories: [Story]?
    var createdStories: [Story]?
    var activeStories: [Story]?
    
    
    public struct defaultsKeys {
        static let user = "userInfo"
    }
    
    override init() {
        super.init()
        let user = PFUser.current()
        self.email = user?.username
        self.firstName = user?.object(forKey: "first_name") as! String?
        self.lastName = user?.object(forKey: "last_name") as! String?
        self.id = user?.objectId

    }
    
    
    static func current() {
        let defaults = UserDefaults.standard
        if let user = defaults.data(forKey: defaultsKeys.user) {
            //Code to return the user
            print(user)
        } else {
            //Someting went wrong
        }
    }
    
}
