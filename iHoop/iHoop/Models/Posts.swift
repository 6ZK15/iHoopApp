//
//  Posts.swift
//  iHoop
//
//  Created by Eric Dowdell on 3/24/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

//
//  Posts.swift
//  iHoop
//
//  Created by Eric Dowdell on 3/24/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import Firebase

struct Posts
{
    var ref: FIRDatabaseReference!
    var key: String!
    var username: String!
    var postId: String!
    var postText: String!
    var profilePicURL: String!
    var postImageURL: String!
    var comments: String!
    var isSwitched: Bool
    
    init(username: String, postId: String, postText: String, profilePicURL: String, postImageURL: String, comments: String,isSwitched: Bool)
    {
        
        self.username = username
        self.postId = postId
        self.postText = postText
        self.profilePicURL = profilePicURL
        self.postImageURL = postImageURL
        self.comments = comments
        self.isSwitched = isSwitched
        
    }
    
    init(snapshot: FIRDataSnapshot){
        let snapshot1 = snapshot.value as? NSDictionary
        self.username = snapshot1?["username"] as! String
        self.postId = snapshot1?["postId"] as! String
        self.postText = snapshot1?["postText"] as! String
        self.profilePicURL = snapshot1?["profilePicURL"] as! String
        self.postImageURL = snapshot1?["postImageURL"] as! String
        self.comments = snapshot1?["comments"] as! String
        self.isSwitched = snapshot1?["isSwitched"] as! Bool
        self.ref = snapshot.ref
        self.key = snapshot.key
        
    }
    
    
    func toAnyObject() -> [String: AnyObject]{
        
        return ["username":username as AnyObject,"postId":postId as AnyObject,"postImageURL":postImageURL as AnyObject,"profilePicURL":profilePicURL as AnyObject, "comments": comments as AnyObject, "isSwitched":isSwitched as AnyObject]
    }
    
    
}
