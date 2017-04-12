//
//  Requests.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/31/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Requests {
    
    fileprivate var _key: String!
    fileprivate var _username: String!
    fileprivate var _fullname: String!
    fileprivate var _userID: String!
//    fileprivate var _profilePic: String!
    
    let databaseReference = FIRDatabase.database().reference()
    
    var key: String {
        return _key
    }
    
    var username: String {
        return _username
    }
    
    var fullname: String {
        return _fullname
    }
    
    var userID: String {
        return _userID
    }
    
//    var profilePic: String {
//        return _profilePic
//    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        
        // Within the Request, or Key, the following properties are children
        
//        if let profilePic = dictionary["profilePic"] as? String {
//            self._profilePic = profilePic
//        }
        
        if let fullname = dictionary["fullname"] as? String {
            self._fullname = fullname
        }
        
        if let username = dictionary["username"] as? String {
            self._username = username
        } else {
            self._username = ""
        }
        
        if let userID = dictionary["uid"] as? String {
            self._userID = userID
        }
    }
    
}
