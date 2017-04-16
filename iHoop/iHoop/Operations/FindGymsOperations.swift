//
//  FindGymsOperations.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/12/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class FindGymsOperations: NSObject {
    
    var names: [String] = []
    var addresses: [String] = []
    
    let currentlongitude = UserDefaults.standard.string(forKey: "currentlongitude")
    let currentlatitude = UserDefaults.standard.string(forKey: "currentlatitude")
    
    func gymURLRequest() {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + "+37.78735890" + "," + "-122.40822700" +  "&radius=500&type=gym&keyword=basketball+gyms&key=AIzaSyC4cyENm7AyJFVyV6GZwgrFbg4d1epEOoo")
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
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! [String : AnyObject]
            print("Gym Request URL: ", json)
            if let gymArray = json["results"] {
                for index in 0...gymArray.count-1 {
                    
                    let aObject = gymArray[index] as! [String : AnyObject]
                    self.names.append(aObject["name"] as! String)
                    self.addresses.append(aObject["vicinity"] as! String)
                    
                }
                print("Gym names: ", self.names)
                print("Gym addresses: ", self.addresses)
            }
        }
        task.resume()
    }

}
