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
    
    /*
     * getListOfRequests
       Returns the list of friends for each user
     */
    func getListOfFriends() {
        databaseReference.child("users").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.friends = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let friendDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let friend = Friends(key: key, dictionary: friendDictionary)
                        
                        self.friends.insert(friend, at: 0)
                    }
                }
            }
        })
    }
    
}
