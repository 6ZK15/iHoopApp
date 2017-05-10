//
//  GroupViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/23/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITextViewDelegate {
    
    //IBOutlets
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var newMsgBtn: UIButton!
    @IBOutlet weak var cancelPostBtn: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var submitMsgButton: UIButton!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var addMemberTableView: UITableView!
    
    //Declare class variables
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    let postOperations = PostOperations()
    let searchController = UISearchController(searchResultsController: nil)
    
    var posts = [Posts]()
    var friends = [Friends]()
    var filteredFriends = [Friends]()
    var members = [Friends]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCheck()
        
        groupName.text = UserDefaults.standard.value(forKey: "groupName") as? String
        getPostsForUser()
        setProfileTextViewDesign()
        setSearchController()
        getListOfFriends()
        getListOfMembers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        
        if tableView == groupTableView {
            count = posts.count
        } else if tableView == addMemberTableView {
            count = filteredFriends.count
        } else if tableView == membersTableView {
            count = members.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var count = CGFloat()
        if tableView == groupTableView {
            count = 100
        } else if tableView == addMemberTableView {
            count = 52
        } else if tableView == membersTableView {
            count = 60
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReturn = UITableViewCell()
        
        if tableView == groupTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! GroupPostsTableViewCell
            let post: Posts = posts[indexPath.row]
            cell.configureCell(post)
            cellReturn = cell 
        } else if tableView == addMemberTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifierTwo", for: indexPath) as! FriendsTableViewCell
            let friend: Friends
            
            if searchController.isActive && searchController.searchBar.text != "" {
                friend = filteredFriends[indexPath.row]
            } else {
                friend = friends[indexPath.row]
            }
            
            cell.configureCell(friend)
            
            cell.setFunction {
                
                guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
                guard let groupLocked = UserDefaults.standard.value(forKey: "groupLocked") else { return }
                guard let groupID = UserDefaults.standard.value(forKey: "groupID") else { return }
                guard let groupPrivacy = UserDefaults.standard.value(forKey: "groupPrivacy") else { return }
                guard let groupLocation = UserDefaults.standard.value(forKey: "groupLocation") else { return }
                
                let groupRef = self.databaseReference.child("users").child(userID as! String).child("groups")
                let memberID = self.databaseReference.child(NSUUID().uuidString)
                let addMemberIndex = self.filteredFriends[indexPath.row]
                
                if groupLocked as! Bool {
                    groupRef.child("public").child(self.groupName.text!).child("members").child(memberID.key).setValue([
                        "uid": addMemberIndex.uid,
                        "username": addMemberIndex.username,
                        "fullname": "\(addMemberIndex.firstname) \(addMemberIndex.lastname)",
                        "firstname": addMemberIndex.firstname,
                        "lastname": addMemberIndex.lastname,
                        "profilePic": addMemberIndex.profilePic
                    ])
                    
                    let membersGroupRef = self.databaseReference.child("users").child(addMemberIndex.uid).child("groups").child("public").child(self.groupName.text!)
                    membersGroupRef.setValue([
                        "groupName": self.groupName.text!,
                        "groupPrivacy": "public",
                        "groupLocation": groupLocation,
                        "groupPic": "nothing as of now",
                        "locked": true
                    ])
                    
                    groupRef.child("public").child(self.groupName.text!).child("members").observe(FIRDataEventType.value, with: {
                        (snapshot) in
                        
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            
                            for snap in snapshots {
                                if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                    let key = snap.key
                                    let member = Friends(key: key, dictionary: memberDictionary)
                                    print("Members' UID:", member.uid)
                                    
                                    membersGroupRef.child("members").child(memberID.key).setValue([
                                        "uid": member.uid,
                                        "username": member.username,
                                        "fullname": "\(member.firstname) \(member.lastname)",
                                        "firstname": member.firstname,
                                        "lastname": member.lastname,
                                        "profilePic": member.profilePic
                                    ])
                                }
                            }
                        }
                    })
                    
                } else {
                    if (groupPrivacy as! String) == "private" {
                        groupRef.child("private").child(groupID as! String).child("members").child(memberID.key).setValue([
                            "uid": addMemberIndex.uid,
                            "username": addMemberIndex.username,
                            "fullname": "\(addMemberIndex.firstname) \(addMemberIndex.lastname)",
                            "firstname": addMemberIndex.firstname,
                            "lastname": addMemberIndex.lastname,
                            "profilePic": addMemberIndex.profilePic
                        ])
                        
                        let membersGroupRef = self.databaseReference.child("users").child(addMemberIndex.uid).child("groups").child("private").child(groupID as! String)
                        membersGroupRef.setValue([
                            "groupName": self.groupName.text!,
                            "groupPrivacy": "public",
                            "groupLocation": groupLocation,
                            "groupPic": "nothing as of now",
                            "locked": true
                        ])
                        
                        groupRef.child("private").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                            (snapshot) in
                            
                            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                
                                for snap in snapshots {
                                    if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        let member = Friends(key: key, dictionary: memberDictionary)
                                        print("Members' UID:", member.uid)
                                        
                                        membersGroupRef.child("members").child(memberID.key).setValue([
                                            "uid": member.uid,
                                            "username": member.username,
                                            "fullname": "\(member.firstname) \(member.lastname)",
                                            "firstname": member.firstname,
                                            "lastname": member.lastname,
                                            "profilePic": member.profilePic
                                        ])
                                    }
                                }
                            }
                        })
                        
                    } else if (groupPrivacy as! String) == "public" {
                        groupRef.child("public").child(groupID as! String).child("members").child(memberID.key).setValue([
                            "uid": addMemberIndex.uid,
                            "username": addMemberIndex.username,
                            "fullname": "\(addMemberIndex.firstname) \(addMemberIndex.lastname)",
                            "firstname": addMemberIndex.firstname,
                            "lastname": addMemberIndex.lastname,
                            "profilePic": addMemberIndex.profilePic
                        ])
                        
                        let membersGroupRef = self.databaseReference.child("users").child(addMemberIndex.uid).child("groups").child("public").child(groupID as! String)
                        membersGroupRef.setValue([
                            "groupName": self.groupName.text!,
                            "groupPrivacy": "public",
                            "groupLocation": groupLocation,
                            "groupPic": "nothing as of now",
                            "locked": true
                        ])
                        
                        groupRef.child("public").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                            (snapshot) in
                            
                            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                
                                for snap in snapshots {
                                    if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        let member = Friends(key: key, dictionary: memberDictionary)
                                        print("Members' UID:", member.uid)
                                        
                                        membersGroupRef.child("members").child(memberID.key).setValue([
                                            "uid": member.uid,
                                            "username": member.username,
                                            "fullname": "\(member.firstname) \(member.lastname)",
                                            "firstname": member.firstname,
                                            "lastname": member.lastname,
                                            "profilePic": member.profilePic
                                        ])
                                    }
                                }
                            }
                        })
                    }
                }
            }
            
            cellReturn = cell
        } else if tableView == membersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberCellIdentifier", for: indexPath) as! MembersTableViewCell
            let member = members[indexPath.row]
            cell.configureCell(member)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cellReturn = cell
        }
        
        return cellReturn
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let repost = UITableViewRowAction(style: UITableViewRowActionStyle.normal,
                                          title: "Repost",
                                          handler: {
                                            (action, index) in
                                            print("Repost Button Tapped")
        })
        repost.backgroundColor = orangeColor
        
        return [repost]
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
     * @IBAction - letsTalkBballBtn
       Shows and hides UITextView for posts
     */
    @IBAction func groupNewMsgBtn(_ sender: Any) {
        showHidePostMsgView()
    }
    
    /*
     * @IBAction - cancelPost
       Shows and hides UITextView for posts
     */
    @IBAction func cancelPost(_ sender: Any) {
        showHidePostMsgView()
    }
    
    @IBAction func postMessage(_ sender: Any) {
        showHidePostMsgView()
        storePostForUser()
        setProfileTextViewDesign()
    }
    
    @IBAction func editGroup(_ sender: Any) {
        showHideMememberView()
    }
    
    /*
     * getPostsForUser
       Retrieves the user's post information
     */
    func getPostsForUser() {
        guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
        guard let groupLocked = UserDefaults.standard.value(forKey: "groupLocked") else { return }
        guard let groupID = UserDefaults.standard.value(forKey: "groupID") else { return }
        guard let groupPrivacy = UserDefaults.standard.value(forKey: "groupPrivacy") else { return }
        
        if groupLocked as! Bool {
            let timelineRef = databaseReference.child("users").child(userID as! String).child("groups").child("public").child(groupName.text!).child("timeline")
            
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
                self.groupTableView.reloadData()
            })
        } else {
            
            if (groupPrivacy as! String) == "private" {
                let timelineRef = databaseReference.child("users").child(userID as! String).child("groups").child("private").child(groupID as! String).child("timeline")
                
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
                    self.groupTableView.reloadData()
                })
            } else if (groupPrivacy as! String) == "public" {
                let timelineRef = databaseReference.child("users").child(userID as! String).child("groups").child("public").child(groupID as! String).child("timeline")
                
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
                    self.groupTableView.reloadData()
                })
            }
        }
    }
    
    /*
     * storePostForUser
       Stores the post information to groups database reference
       Input: msgTextView as! UITextView
     */
    func storePostForUser() {
        guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
        let postID = self.databaseReference.child("users").child(NSUUID().uuidString)
        let postMessage = msgTextView.text
        UserDefaults.standard.set(postID.key, forKey: "postID")
        
        //Date Post Format
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let timeStamp = dateFormatter.string(from: date)
        
        //Date to remove post
        var removeTimeStamp = dateFormatter.string(from:date)
        let curr = NSDate(timeIntervalSinceNow: 86400)
        removeTimeStamp = dateFormatter.string(from:curr as Date)
        print(removeTimeStamp)
        
        //Date Database Format
        let dateReferenceFormatter = DateFormatter()
        dateReferenceFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateReferenceFormatter.dateFormat = "MMMM d h:mm:ss"
        let timeStampRef = dateReferenceFormatter.string(from: date)
        
        
        
        //Store Post for current group
        guard let groupLocked = UserDefaults.standard.value(forKey: "groupLocked") else { return }
        guard let groupID = UserDefaults.standard.value(forKey: "groupID") else { return }
        guard let groupPrivacy = UserDefaults.standard.value(forKey: "groupPrivacy") else { return }
        let groupRef = databaseReference.child("users").child(userID as! String).child("groups")
        print("current user: %@", userID as Any)
        
        if groupLocked as! Bool {
            groupRef.child("public").child(groupName.text!).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                "post":postMessage,
                "postAttachmentURL":"",
                "timeStamp":timeStamp,
                "deleteTimeStamp": removeTimeStamp
            ])
            
            groupRef.child("public").child(groupName.text!).child("members").observe(FIRDataEventType.value, with: {
                (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshots {
                        if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let member = Friends(key: key, dictionary: memberDictionary)
                            let memberID = member.uid
                            print("Members' UID:", memberID)
                            
                            let memberRef = self.databaseReference.child("users").child(memberID).child("groups")
                            memberRef.child("public").child(self.groupName.text!).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                                "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                                "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                                "post":postMessage,
                                "postAttachmentURL":"",
                                "timeStamp":timeStamp,
                                "deleteTimeStamp": removeTimeStamp
                            ])
                        }
                    }
                }
            })
            
        } else {
            
            if (groupPrivacy as! String) == "private" {
                groupRef.child("private").child(groupID as! String).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                    "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                    "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                    "post":postMessage,
                    "postAttachmentURL":"",
                    "timeStamp":timeStamp,
                    "deleteTimeStamp": removeTimeStamp
                ])
                
                groupRef.child("private").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshots {
                            if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let member = Friends(key: key, dictionary: memberDictionary)
                                let memberID = member.uid
                                print("Members' UID:", memberID)
                                
                                let memberRef = self.databaseReference.child("users").child(memberID).child("groups")
                                memberRef.child("private").child(groupID as! String).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                                    "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                                    "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                                    "post":postMessage,
                                    "postAttachmentURL":"",
                                    "timeStamp":timeStamp,
                                    "deleteTimeStamp": removeTimeStamp
                                ])
                            }
                        }
                    }
                })
                
            } else {
                groupRef.child("public").child(groupID as! String).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                    "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                    "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                    "post":postMessage,
                    "postAttachmentURL":"",
                    "timeStamp":timeStamp,
                    "deleteTimeStamp": removeTimeStamp
                ])
                
                groupRef.child("public").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshots {
                            if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let member = Friends(key: key, dictionary: memberDictionary)
                                let memberID = member.uid
                                print("Members' UID:", memberID)
                                
                                let memberRef = self.databaseReference.child("users").child(memberID).child("groups")
                                memberRef.child("public").child(groupID as! String).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                                    "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                                    "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                                    "post":postMessage,
                                    "postAttachmentURL":"",
                                    "timeStamp":timeStamp,
                                    "deleteTimeStamp": removeTimeStamp
                                ])
                            }
                        }
                    }
                })
                
            }
        }
    }
    
    func postCheck() {
        guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
        guard let groupLocked = UserDefaults.standard.value(forKey: "groupLocked") else { return }
        guard let groupID = UserDefaults.standard.value(forKey: "groupID") else { return }
        guard let groupPrivacy = UserDefaults.standard.value(forKey: "groupPrivacy") else { return }
        
        //Date Database Format
        let date = Date()
        let dateReferenceFormatter = DateFormatter()
        dateReferenceFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateReferenceFormatter.dateFormat = "MMMM d h:mm:ss"
        let timeStamp = dateReferenceFormatter.string(from: date)
        print("timeStampRef: ", timeStamp)
        
        let groupRef = databaseReference.child("users").child(userID as! String).child("groups")
        
        if groupLocked as! Bool {
            groupRef.child("public").child(groupName.text!).child("timeline").observe(FIRDataEventType.value, with: {
                (snapshot) in
                //everything in time line
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    //all information in each post
                    for snap in snapshots {
                        if let PostDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let posts = Posts(key: key, dictionary: PostDictionary)
                            let postStamp = posts.postTimeStamp
                            let deleteStamp = posts.deleteTimeStamp
                            print("Timestamp:", postStamp)
                            print("Delete Stamp:", deleteStamp)
                            print(posts.postKey)
                            
                            if timeStamp >= deleteStamp {
                                groupRef.child("public").child(self.groupName.text!).child("timeline").child(posts.postKey).removeValue()
                            }
                        }
                    }
                }
            })
        } else {
            if (groupPrivacy as! String) == "private" {
                groupRef.child("private").child(groupID as! String).child("timeline").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    //everything in time line
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        //all information in each post
                        for snap in snapshots {
                            if let PostDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let posts = Posts(key: key, dictionary: PostDictionary)
                                let postStamp = posts.postTimeStamp
                                let deleteStamp = posts.deleteTimeStamp
                                print("Timestamp:", postStamp)
                                print("Delete Stamp:", deleteStamp)
                                print(posts.postKey)
                                
                                if timeStamp >= deleteStamp {
                                    groupRef.child("private").child(groupID as! String).child("timeline").child(posts.postKey).removeValue()
                                }
                            }
                        }
                    }
                })
            } else {
                groupRef.child("public").child(groupID as! String).child("timeline").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    //everything in time line
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        //all information in each post
                        for snap in snapshots {
                            if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let posts = Posts(key: key, dictionary: postDictionary)
                                let postStamp = posts.postTimeStamp
                                let deleteStamp = posts.deleteTimeStamp
                                print("Timestamp:", postStamp)
                                print("Delete Stamp:", deleteStamp)
                                print(posts.postKey)
                                
                                if timeStamp >= deleteStamp {
                                    groupRef.child("public").child(groupID as! String).child("timeline").child(posts.postKey).removeValue()
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func setSearchController() {
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.view.backgroundColor = UIColor.clear
        searchController.searchBar.barTintColor = UIColor.clear
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
        addMemberTableView.tableHeaderView = searchController.searchBar
        addMemberTableView.tableHeaderView?.alpha = 0
    }
    
    func getListOfFriends() {
        guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
        databaseReference.child("users").child(userID as! String).child("friends").observe(FIRDataEventType.value, with: {
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
            print("List of friends: ", self.friends)
        })
    }
    
    func getListOfMembers() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let groupLocked = UserDefaults.standard.value(forKey: "groupLocked")
        let groupID = UserDefaults.standard.value(forKey: "groupID")
        let groupPrivacy = UserDefaults.standard.value(forKey: "groupPrivacy")
        
        let groupRef = self.databaseReference.child("users").child(userID as! String).child("groups")
        
        if groupLocked as! Bool {
            groupRef.child("public").child(self.groupName.text!).child("members").observe(FIRDataEventType.value, with: {
                (snapshot) in
                self.members = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let member = Friends(key: key, dictionary: memberDictionary)
                            self.members.insert(member, at: 0)
                        }
                    }
                }
                self.membersTableView.reloadData()
                print("List of members", self.members)
            })
        } else {
            if (groupPrivacy as! String) == "private" {
                groupRef.child("private").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    self.members = []
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let member = Friends(key: key, dictionary: memberDictionary)
                                self.members.insert(member, at: 0)
                            }
                        }
                    }
                    self.membersTableView.reloadData()
                    print("List of members", self.members)
                })
            } else if (groupPrivacy as! String) == "public" {
                groupRef.child("public").child(groupID as! String).child("members").observe(FIRDataEventType.value, with: {
                    (snapshot) in
                    self.members = []
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            if let memberDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let member = Friends(key: key, dictionary: memberDictionary)
                                self.members.insert(member, at: 0)
                            }
                        }
                    }
                    self.membersTableView.reloadData()
                    print("List of members", self.members)
                })
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter({( friend : Friends) -> Bool in
            return friend.username.lowercased().contains(searchText.lowercased())
        })
        addMemberTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    /*
     * showHidePostMsgView
       Shows and hides UITextView for posting messages
     */
    func showHidePostMsgView() {
        if messageView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.groupTableView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.messageView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.newMsgBtn.alpha = 0
                self.cancelPostBtn.alpha = 1
                self.messageView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.groupTableView.transform = .identity
                self.messageView.transform = .identity
                self.messageView.alpha = 0
                self.cancelPostBtn.alpha = 0
                self.newMsgBtn.alpha = 1
            })
        }
    }
    
    func showHideMememberView() {
        if membersTableView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.membersTableView.transform = CGAffineTransform.init(translationX: -64, y: 0)
                self.backBtn.alpha = 0
                self.newMsgBtn.alpha = 0
                self.gradientView.alpha = 0.9
                self.addMemberTableView.alpha = 1
                self.searchController.searchBar.alpha = 1
                self.addMemberTableView.tableHeaderView?.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.membersTableView.transform = .identity
                self.backBtn.alpha = 1
                self.newMsgBtn.alpha = 1
                self.gradientView.alpha = 0
                self.addMemberTableView.alpha = 0
                self.searchController.searchBar.alpha = 0
                self.addMemberTableView.tableHeaderView?.alpha = 0
            })
        }
    }
    
    /*
     * setProfileTextViewDesign
       Sets Profile UITextView design for posting messages
     */
    func setProfileTextViewDesign() {
        msgTextView.delegate = self
        msgTextView.layer.cornerRadius = 8
        msgTextView.layer.borderWidth = 2
        msgTextView.layer.borderColor = orangeColor.cgColor
        msgTextView.backgroundColor = UIColor.black
        msgTextView.text = "Enter Message"
        msgTextView.textColor = UIColor.lightGray
        msgTextView.isUserInteractionEnabled = true
    }
    
    /*
     * textViewDidBeginEditing
       Sets design when textView has begun editing
       Input: textView as! UITextView
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    /*
     * textViewDidEndEditing
       Sets design when textView has ended editing
       Input: textView as! UITextView
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Message"
            textView.textColor = UIColor.lightGray
        }
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
