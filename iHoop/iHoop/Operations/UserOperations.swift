//
//  UserOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserOperations: NSObject {
    
    let databaseReference = FIRDatabase.database().reference()
    
    /*
     * getCurrentUserInfo
       Gets user information from database reference and stores value as UserDefaults key
     */
    func getCurrentUserInfo() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        print("current user: %@", userID as Any)
        let queryRef = databaseReference.child("users")
        queryRef.child(userID as! String).observeSingleEvent(of: FIRDataEventType.value, with: {
            (snapshot) in
            print("Current User Info:\n", snapshot.value as! NSDictionary)
            queryRef.child(userID as! String + "/profilepic").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "profileImageURL")
                print("Profile Image URL", snapshot.value as Any)
            })
            queryRef.child(userID as! String + "/username").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "profileUsername")
            })
            queryRef.child(userID as! String + "/firstname").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "firstname")
            })
            queryRef.child(userID as! String + "/lastname").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "lastname")
            })
        })
    }

}
