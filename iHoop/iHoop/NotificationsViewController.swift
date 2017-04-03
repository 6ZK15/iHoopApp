//
//  NotificationsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/29/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var notificationsTableView: UITableView!
    
    var requests = [Requests]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.synchronize()
        
        getListOfRequests()
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! RequestTableViewCell
        let request = requests[indexPath.row]
        
        cell.configureCell(request)
        
        cell.setFunction {
            let requestID = request.key
            let requestUsername = request.username
            
            if cell.requestResponse.selectedSegmentIndex == 0 {
                self.acceptFriendRequest(requestID, requestUsername)
                cell.requestResponse.isSelected = false
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getListOfRequests() {
        let username = UserDefaults.standard.value(forKey: "profileUsername") as! String
        
        databaseReference.child("requests").child(username).observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.requests = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let requestDictionary = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let request = Requests(key: key, dictionary: requestDictionary)
                        
                        self.requests.insert(request, at: 0)
                        
                        let tabItem = self.tabBarController?.tabBar.items![4]
                        let requestBadge = String(self.requests.count)
                        tabItem?.badgeValue = requestBadge
                        tabItem?.badgeColor = self.orangeColor
                    }
                }
                
            }
            print("List of Requests: ", self.requests)
            self.notificationsTableView.reloadData()
        })
    }
    
    func acceptFriendRequest(_ requestID: String, _ requestUsername: String) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let username = UserDefaults.standard.value(forKey: "profileUsername") as! String
        
        databaseReference.child("requests").child(username).child(requestID).removeValue()
        databaseReference.child("users").child(userID!).child("friends").setValue([
            requestUsername:true
        ])
        databaseReference.child("requests").child(username).child(requestID).child("uid").observe(FIRDataEventType.value, with: {
            (snapshot) in
            UserDefaults.standard.set(snapshot.value as Any, forKey: "requestUserID")
        })
        let requestUserID = UserDefaults.standard.value(forKey: "requestUserID") as! String
        databaseReference.child("users").child(requestUserID).child("friends").setValue([
            username:true
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
