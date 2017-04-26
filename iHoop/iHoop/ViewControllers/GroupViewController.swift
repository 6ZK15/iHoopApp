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

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITextViewDelegate {
    
    //IBOutlets
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var newMsgBtn: UIButton!
    @IBOutlet weak var cancelPostBtn: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var submitMsgButton: UIButton!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var membersTableView: GroupMembersTableView!
    
    //Declare class variables
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    let postOperations = PostOperations()
    
    var posts = [Posts]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupName.text = UserDefaults.standard.value(forKey: "groupName") as? String
        getPostsForUser()
        setProfileTextViewDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! PostsTableViewCell
        let post = posts[indexPath.row]
        
        cell.configureCell(post)
        
        return cell
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
        storePublicPostForUser()
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
            } else {
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
     * storePublicPostForUser
       Stores the post information to groups database reference
       Input: msgTextView as! UITextView
     */
    func storePublicPostForUser() {
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
            } else {
                groupRef.child("public").child(groupID as! String).child("timeline").child(timeStampRef + " " + postID.key).setValue([
                    "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
                    "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
                    "post":postMessage,
                    "postAttachmentURL":"",
                    "timeStamp":timeStamp,
                    "deleteTimeStamp": removeTimeStamp
                ])
            }
        }
        
        
        //Store Post for group members
//        databaseReference.child("users").child(userID as! String + "/friends").observe(FIRDataEventType.value, with: {
//            (snapshot) in
//            
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                
//                for snap in snapshots {
//                    if let friendDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let friend = Friends(key: key, dictionary: friendDictionary)
//                        let friendID = friend.uid
//                        print("Friends' UID:", friendID)
//                        
//                        let friendsRef = self.databaseReference.child("users").child(friendID)
//                        friendsRef.child("timeline").child(timeStampRef + " " + postID.key).setValue([
//                            "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
//                            "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
//                            "post":postMessage,
//                            "postAttachmentURL":"",
//                            "timeStamp":timeStamp,
//                            "deleteTimeStamp": removeTimeStamp
//                        ])
//                    }
//                }
//            }
//        })
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
                self.newMsgBtn.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.membersTableView.transform = .identity
                self.newMsgBtn.alpha = 1
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
