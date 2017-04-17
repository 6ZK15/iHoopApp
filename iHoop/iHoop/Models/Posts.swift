//
//  Posts.swift
//  iHoop
//
//  Created by Eric Dowdell on 3/24/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Posts {
    
    fileprivate var _postKey: String!
    fileprivate var _postMessage: String!
    fileprivate var _postTimeStamp: String!
    fileprivate var _deleteTimeStamp: String!
    fileprivate var _username: String!
    
    let databaseReference = FIRDatabase.database().reference()
    
    var postKey: String {
        return _postKey
    }
    
    var postMessage: String {
        return _postMessage
    }
    
    var postTimeStamp: String {
        return _postTimeStamp
    }
    var deleteTimeStamp: String {
        return _deleteTimeStamp
    }
    
    
    var username: String {
        return _username
    }
    
    // Initialize the new Post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = key
        
        // Within the Post, or Key, the following properties are children
        
        if let timeStamp = dictionary["timeStamp"] as? String {
            self._postTimeStamp = timeStamp
        }
        
        if let deleteTimeStamp = dictionary["deleteTimeStamp"] as? String {
            self._deleteTimeStamp = deleteTimeStamp
        }
        if let post = dictionary["post"] as? String {
            self._postMessage = post
        }
        
        if let username = dictionary["username"] as? String {
            self._username = username
        } else {
            self._username = ""
        }
    }
    
}
