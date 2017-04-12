//
//  Groups.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Groups {
    
    fileprivate var _key: String!
    fileprivate var  _uid: String!
    fileprivate var _groupName: String!
    fileprivate var _groupPrivacy: String!
    fileprivate var _groupLocation: String!
    fileprivate var _groupImage: String!
    
    var key: String {
        return _key
    }
    
    var uid: String {
        return _uid
    }
    
    var groupName: String {
        return _groupName
    }
    
    var groupPrivacy: String {
        return _groupPrivacy
    }
    
    var groupLocation: String {
        return _groupLocation
    }
    
    var groupImage: String {
        return _groupImage
    }
    
    init(key: String, dictionary: Dictionary<String,AnyObject>) {
        self._key = key
        
        if let uid = dictionary["uid"] as? String {
            self._uid = uid
        }
        
        if let groupName = dictionary["groupName"] as? String {
            self._groupName = groupName
        }
        
        if let groupPrivacy = dictionary["groupPrivacy"] as? String {
            self._groupPrivacy = groupPrivacy
        }
        
        if let groupLocation = dictionary["groupLocation"] as? String {
            self._groupLocation = groupLocation
        }
        
        if let groupImage = dictionary["groupPic"] as? String {
            self._groupImage = groupImage
        }
    }
    
}
