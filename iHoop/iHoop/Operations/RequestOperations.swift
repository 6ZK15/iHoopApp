//
//  RequestOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestOperations: NSObject {
    
    var requests = [Requests]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    /*
     * acceptFriendRequest
       Accepts and stores the friend's request information to users database reference
       Input: requestID or key; requestUserID; requestUsername
     */
    func acceptFriendRequest(_ requestID: String,
                             _ requestUserID: String,
                             _ requestUsername: String,
                             _ requestFirstname: String,
                             _ requestLastname: String,
                             _ requestProfilePic: String) {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let username = UserDefaults.standard.value(forKey: "profileUsername") as! String
        let firstname = UserDefaults.standard.value(forKey: "firstname") as! String
        let lastname = UserDefaults.standard.value(forKey: "lastname") as! String
        let profilePic = UserDefaults.standard.value(forKey: "profileImageURL") as! String
        let friendID = self.databaseReference.child("users").child("friends").child(NSUUID().uuidString)
        
        databaseReference.child("requests").child(username).child(requestID).removeValue()
        databaseReference.child("users").child(userID!).child("friends").child(friendID.key).setValue([
            "uid":requestUserID,
            "username":requestUsername,
            "firstname":requestFirstname,
            "lastname":requestLastname,
            "profilePic": requestProfilePic
        ])
        databaseReference.child("users").child(requestUserID).child("friends").child(friendID.key).setValue([
            "uid":userID!,
            "username":username,
            "firstname":firstname,
            "lastname":lastname,
            "profilePic":profilePic
        ])
    }
    
    /*
     * declineFriendRequest
       Declines and removes the friend request information from database reference
       Input: requestID or key
     */
    func declineFriendRequest(_ requestID: String) {
        let username = UserDefaults.standard.value(forKey: "profileUsername") as! String
        databaseReference.child("requests").child(username).child(requestID).removeValue()
    }

}
