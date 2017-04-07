//
//  ProfileViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/22/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITextViewDelegate {

    //IBOutlets
    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var ltbTableView: UITableView!
    @IBOutlet weak var ltbButton: UIButton!
    @IBOutlet weak var cancelPostBtn: UIButton!
    @IBOutlet weak var ltbSubmitButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var menuBtn: UIButton!
    
    //Declare class variables
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    let postOperations = PostOperations()
    let requestOperations = RequestOperations()
    let userOperations = UserOperations()
    
    var posts = [Posts]()
    var requests = [Requests]()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.synchronize()
        
        userOperations.getCurrentUserInfo()
        getPostsForUser()
        getListOfRequests()
        
//        setProfilePic()
        setProfileUsername()
        setProfileTextViewDesign()
        
        
        profileImageClass.setProfileImageDesign(profileImage)
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        repost.backgroundColor = UIColor.lightGray
        
        return [repost]
    }
    
    /*
     * @IBAction - letsTalkBballBtn
       Shows and hides UITextView for posts
     */
    @IBAction func letsTalkBballBtn(_ sender: Any) {
        showHidePostMsgView()
    }
    /*
     * @IBAction - cancelPost
       Shows and hides UITextView for posts
     */
    @IBAction func cancelPost(_ sender: Any) {
        showHidePostMsgView()
    }
    
    /*
     * @IBAction - postMessage
       Shows and hides UITextView for posting messages
       Stores posts for user in database reference
       Sets the design of UITextView for posts
     */
    @IBAction func postMessage(_ sender: Any) {
        showHidePostMsgView()
        storePostForUser()
        setProfileTextViewDesign()
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
            self.ltbTableView.reloadData()
        })
    }
    
    /*
     * storePostForUser
     Stores the post information to users database reference
     Input: msgTextView as! UITextView
     */
    func storePostForUser() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
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
        
        //Date Database Format
        let dateReferenceFormatter = DateFormatter()
        dateReferenceFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateReferenceFormatter.dateFormat = "MMMM d h:mm:ss"
        let timeStampRef = dateReferenceFormatter.string(from: date)
        
        //Store Post for current user
        print("current user: %@", userID as Any)
        let userRef = databaseReference.child("users").child(userID as! String)
        userRef.child("timeline").child(timeStampRef + " " + postID.key).setValue([
            "username": UserDefaults.standard.value(forKey: "profileUsername") as? String,
            "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as? String,
            "post":postMessage,
            "postAttachmentURL":"",
            "timeStamp":timeStamp,
        ])
        
        //Store Post for friends
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
     * getListOfRequests
       Returns the list of friend requests for each user and displays the badgeValue for the total of requests
     */
    func getListOfRequests() {
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
                        
                        let tabItem = self.tabBarController?.tabBar.items![4]
                        let requestBadge = String(self.requests.count)
                        tabItem?.badgeValue = requestBadge
                        tabItem?.badgeColor = self.orangeColor
                    }
                }
            }
        })
    }
    
    /*
     * showHidePostMsgView
       Shows and hides UITextView for posting messages
     */
    func showHidePostMsgView() {
        if messageView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.ltbTableView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.messageView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.ltbButton.alpha = 0
                self.cancelPostBtn.alpha = 1
                self.messageView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.ltbTableView.transform = .identity
                self.messageView.transform = .identity
                self.messageView.alpha = 0
                self.cancelPostBtn.alpha = 0
                self.ltbButton.alpha = 1
            })
        }
    }
    
    /*
     * setProfilePic
       Sets Profile Pic for user
     */
    func setProfilePic() {
        let profileImageURL = UserDefaults.standard.value(forKey: "profileImageURL")
        
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL:profileImageURL as! String)
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.profileImage.image = image
        }
    }
    
    /*
     * setProfileUsername
       Sets Profile Username for user
     */
    func setProfileUsername() {
        let profileUsername = UserDefaults.standard.string(forKey: "profileUsername") ?? "Username Not Found"
        welcomeUserLabel.text = "Welcome " + profileUsername + "!"
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
