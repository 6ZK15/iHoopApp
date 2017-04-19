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
    let currentlongitude = UserDefaults.standard.string(forKey: "currentlongitude")!
    let currentlatitude = UserDefaults.standard.string(forKey: "currentlatitude")!
    
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
    
    func gymURLRequest() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + currentlatitude + "," + currentlongitude +  "&radius=66000&type=gym&keyword=basketball+recreation+centers&key=AIzaSyC4cyENm7AyJFVyV6GZwgrFbg4d1epEOoo")
        print(url as Any)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, AnyObject>
            print("Gym Response Dictionary: ", json!)
            
            self.databaseReference.child("users").child(userID as! String).child("nearby").setValue(json)
            
            self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").observe(FIRDataEventType.value, with: {
                (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let gymDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let gym = Gyms.init(key: key, dictionary: gymDictionary)
                            self.gyms.insert(gym, at: 0)
                            self.names.append(gym.gymName)
                            
                            let locationRef = self.databaseReference.child("users").child(userID as! String).child("nearby").child("results").child(key).child("geometry").child("location")
                            
                            locationRef.child("lat").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let latitude = snapshot.value {
                                    self.latitudes.append(latitude as! CLLocationDegrees)
                                }
                                UserDefaults.standard.set(self.latitudes, forKey: "latitudes")
                            })
                            
                            locationRef.child("lng").observeSingleEvent(of: FIRDataEventType.value, with: {
                                (snapshot) in
                                if let longitude = snapshot.value {
                                    self.longitudes.append(longitude as! CLLocationDegrees)
                                }
                                UserDefaults.standard.set(self.longitudes, forKey: "longitudes")
                            })
                        }
                    }
                }
                print("gymList: ", self.gyms)
                print("gymNames: ", self.names)
            })
            
        }
        task.resume()
    }

}
