//
//  FindGymsOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/12/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class FindGymsOperations: NSObject {
    
    var gyms = [Gyms]()
    var names: [String] = []
    var latitudes: [CLLocationDegrees] = []
    var longitudes: [CLLocationDegrees] = []
    
    let databaseReference = FIRDatabase.database().reference()
    
    func getGymNames() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let gymDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let gym = Gyms.init(key: key, dictionary: gymDictionary)
                        self.names.append(gym.gymName)
                        UserDefaults.standard.set(self.names, forKey: "gymNames")
                    }
                }
            }
        })
    }

}
