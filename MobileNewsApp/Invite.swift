//
//  Invite.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/13/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import Foundation
import Parse

class Invite {
    var to: String!
    var from: String!
    var fromObject: User? = nil
    var id: String!
    
    init(to: String, from: String, id: String) {
        self.to = to
        self.from = from
        self.id = id
    }
    
    
    //Function to delete invite from DB using ID, gonna have to try and delete all
    //Duplicates are gonna be annoying
    func delete() {
        
    }
    
    static func getUsers(usersIds: [String], completion: ((_ users: [User]?, _ error: Error?) -> Void)?) {
        let query:PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: usersIds)
        
        query.findObjectsInBackground(block: {(users: [PFObject]?, error: Error?) -> Void in
            var returnArray =  [User]()
            var returnError: Error? = nil
            if error != nil
            {
                returnError = error!
                print("Error getting invites")
            }
            else
            {
                print("successfully retrieved invites")
                returnArray = User.convertToUsers(userObjects: users!)
                
            }
            
            if completion != nil {
                completion!(returnArray, returnError)
            }
            
        })

    }
    
    static func getInvitesByUser(userId: String, completion: ((_ invites: [Invite]?, _ error: Error?) -> Void)?) {
        let query: PFQuery = PFQuery(className: "Invite")
        query.whereKey("to", equalTo: userId)
        
        query.findObjectsInBackground(block: {(invites: [PFObject]?, error: Error?) -> Void in
            var returnArray =  [Invite]()
            var returnError: Error? = nil
            if error != nil
            {
                returnError = error!
                print("Error getting invites")
            }
            else
            {
                print("successfully retrieved invites")
                returnArray = convertToInvite(objArray: invites!)
                
            }
            
            if completion != nil {
                completion!(returnArray, returnError)
            }
            
        })
    }
    
    static func convertToInvite(objArray: [PFObject]) -> [Invite] {
        
        var inviteArray = [Invite]()
        for invite in objArray {
            inviteArray.append(Invite(to: invite.object(forKey: "to") as! String,
                                      from: invite.object(forKey: "from") as! String,
                                      id: invite.objectId!))
        }
        
        return inviteArray
    }
    
}
