//
//  Gyms.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/14/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

struct Gyms {
    
    fileprivate var _gymKey: String!
    fileprivate var _gymName: String!
    fileprivate var _address: String!
    fileprivate var _placeID: String!
    
    var gymKey: String {
        return _gymKey
    }
    
    var gymName: String {
        return _gymName
    }
    
    var address: String {
        return _address
    }
    
    var placeID: String {
        return _placeID
    }
    
    // Initialize the new Post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._gymKey = key
        
        // Within the Post, or Key, the following properties are children
        
        if let gymName = dictionary["name"] as? String {
            self._gymName = gymName
        }
        
        if let address = dictionary["vicinity"] as? String {
            self._address = address
        }
        
        if let placeID = dictionary["place_id"] as? String {
            self._placeID = placeID
        }
    }
    
}
