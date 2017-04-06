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
     * getListOfRequests
       Returns the list of friend requests for each user and displays the badgeValue for the total of requests
       Input: tabBarController as! TabBarController
     */
    func getListOfRequests(_ tabBarController: TabBarController) {
        let username = UserDefaults.standard.string(forKey: "profileUsername") ?? "Error"
        
        databaseReference.child("requests").child(username).observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.requests = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let requestDictionary = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let request = Requests(key: key, dictionary: requestDictionary)
                        
                        self.requests.insert(request, at: 0)
                        
                        let tabItem = tabBarController.tabBar.items![4]
                        let requestBadge = String(self.requests.count)
                        tabItem.badgeValue = requestBadge
                        tabItem.badgeColor = self.orangeColor
                    }
                }
            }
            print("List of Requests: ", self.requests)
        })
    }
    
    /*
     * acceptFriendRequest
       Accepts and stores the friend's request information to users database reference
       Input: requestID or key; requestUserID; requestUsername
     */
    func acceptFriendRequest(_ requestID: String, _ requestUserID: String, _ requestUsername: String) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let username = UserDefaults.standard.value(forKey: "profileUsername") as! String
        let friendID = self.databaseReference.child("users").child("friends").child(NSUUID().uuidString)
        
        databaseReference.child("requests").child(username).child(requestID).removeValue()
        databaseReference.child("users").child(userID!).child("friends").child(friendID.key).setValue([
            "uid":requestUserID,
            requestUsername:true
        ])
        databaseReference.child("users").child(requestUserID).child("friends").child(friendID.key).setValue([
            "uid":userID!,
            username:true
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
