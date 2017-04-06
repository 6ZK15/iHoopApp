//
//  PostOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostOperations: NSObject {
    
    var posts = [Posts]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    /*
     * storePostForUser
       Stores the post information to users database reference
       Input: msgTextView as! UITextView
     */
    func storePostForUser(_ msgTextView: UITextView) {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let postID = self.databaseReference.child("users").child(NSUUID().uuidString)
        let postMessage = msgTextView.text
        UserDefaults.standard.set(postID.key, forKey: "postID")
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let timeStamp = dateFormatter.string(from: date)
        
        let dateReferenceFormatter = DateFormatter()
        dateReferenceFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateReferenceFormatter.dateFormat = "MMMM d h:mm:ss a"
        dateReferenceFormatter.amSymbol = "AM"
        dateReferenceFormatter.pmSymbol = "PM"
        
        let timeStampRef = dateReferenceFormatter.string(from: date)
        
        print("current user: %@", userID as Any)
        let userRef = databaseReference.child("users").child(userID as! String)
        userRef.child("timeline").child(timeStampRef + " " + postID.key).setValue([
            "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
            "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
            "post":postMessage,
            "postAttachmentURL":"",
            "timeStamp":timeStamp,
        ])
        
        databaseReference.child("users").child(userID as! String + "/friends").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let friendDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let friend = Friends(key: key, dictionary: friendDictionary)
                        let friendID = friend.uid
                        print("Friends' UID:", friendID)
                        
                        let friendsRef = self.databaseReference.child("users").child(friendID)
                        friendsRef.child("timeline").child(timeStampRef + " " + postID.key).setValue([
                            "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                            "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                            "post":postMessage,
                            "postAttachmentURL":"",
                            "timeStamp":timeStamp,
                            ])
                    }
                }
            }
        })
    }
    
    /*
     * getPostsForUser
       Retrieves the user's post information
     */
    func getPostsForUser() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let timelineRef = databaseReference.child("users").child(userID as! String).child("timeline")
        
        timelineRef.observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Posts(key: key, dictionary: postDictionary)
                        self.posts.insert(post, at: 0)
                    }
                }
            }
        })
    }

}
