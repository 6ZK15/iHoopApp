//
//  FriendOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendOperations: NSObject {
    
    var friends = [Friends]()
    
    let databaseReference = FIRDatabase.database().reference()
    
}
