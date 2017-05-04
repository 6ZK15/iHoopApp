//
//  Accessories.swift
//  iHoop
//
//  Created by Nehemiah Horace on 5/3/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

struct Items {
    
    fileprivate var _itemKey: String!
    fileprivate var _brand: String!
    fileprivate var _itemImage: String!
    fileprivate var _itemInfo: String!
    fileprivate var _itemName: String!
    
    var itemKey: String {
        return _itemKey
    }
    
    var brand: String {
        return _brand
    }
    
    var itemImage: String {
        return _itemImage
    }
    
    var itemInfo: String {
        return _itemInfo
    }
    
    var itemName: String {
        return _itemName
    }
    
    // Initialize the new Post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._itemKey = key
        
        // Within the Post, or Key, the following properties are children
        
        if let brand = dictionary["brand"] as? String {
            self._brand = brand
        }
        
        if let itemImage = dictionary["itemImage"] as? String {
            self._itemImage = itemImage
        }
        
        if let itemInfo = dictionary["itemInfo"] as? String {
            self._itemInfo = itemInfo
        }
        
        if let itemName = dictionary["itemName"] as? String {
            self._itemName = itemName
        }
    }
    
}
