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
    fileprivate var _firstname: String!
    fileprivate var _lastname: String!
    fileprivate var _profilePic: String!
    
    let databaseReference = FIRDatabase.database().reference()
    
    var key: String {
        return _key
    }
    
    var username: String {
        return _username
    }
    
    var firstname: String {
        return _firstname
    }
    
    var lastname: String {
        return _lastname
    }
    
    var profilePic: String {
        return _profilePic
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        
        // Within the Post, or Key, the following properties are children
        
        if let profilePic = dictionary["profilePic"] as? String {
            self._profilePic = profilePic
        }
        
        if let firstname = dictionary["firstname"] as? String {
            self._firstname = firstname
        }
        
        if let lastname = dictionary["lastname"] as? String {
            self._lastname = lastname
        } else if let lastname = dictionary["lastname:"] as? String {
            self._lastname = lastname
        }
        
        if let username = dictionary["username"] as? String {
            self._username = username
        } else {
            self._username = ""
        }
    }
    
}
