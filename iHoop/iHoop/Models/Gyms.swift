//
//  Gyms.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/14/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import CoreLocation

struct Gyms {
    
    fileprivate var _gymKey: String!
    fileprivate var _gymName: String!
    fileprivate var _address: String!
    fileprivate var _geometry: Dictionary<String, AnyObject>!
    fileprivate var _location: Dictionary<String, AnyObject>!
    
    var gymKey: String {
        return _gymKey
    }
    
    var gymName: String {
        return _gymName
    }
    
    var address: String {
        return _address
    }
    
    var geometry: Dictionary<String, AnyObject> {
        return _geometry
    }
    
    var location: Dictionary<String, AnyObject> {
        return _location
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
        
        if let geometry = dictionary["geometry"] as? Dictionary<String, AnyObject> {
            self._geometry = geometry
        }
    }
    
}
