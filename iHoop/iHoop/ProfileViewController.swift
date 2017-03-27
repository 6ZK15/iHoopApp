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

    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var ltbTableView: UITableView!
    @IBOutlet weak var ltbButton: UIButton!
    @IBOutlet weak var ltbSubmitButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextView: UITextView!
    
    
    
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentUserInfo()
//        setProfilePic()
        setProfileUsername()
        setProfileTextViewDesign()
        
        profileImageClass.setProfileImageDesign(profileImage)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        
        return cell
    }
    
    @IBAction func letsTalkBballBtn(_ sender: Any) {
        showHidePostMsgView()
    }
    
    @IBAction func postMessage(_ sender: Any) {
        showHidePostMsgView()
        storePostForUser()
    }
    
    func showHidePostMsgView() {
        if messageView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.ltbTableView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.messageView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
                self.ltbButton.alpha = 0
                self.messageView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.ltbTableView.transform = .identity
                self.messageView.transform = .identity
                self.messageView.alpha = 0
                self.ltbButton.alpha = 1
            })
        }
    }
    
    func storePostForUser() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let postID = self.databaseReference.child("users").child(NSUUID().uuidString)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm"
        let currentTime = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let timeStamp = dateFormatter.string(from: date)
        
        
        print("current user: %@", userID as Any)
        let queryRef = databaseReference.child(userID as! String)
        queryRef.child("posts").child(postID.key).setValue([
            "username": UserDefaults.standard.value(forKey: "profileUsername") as! String,
            "profileImage": UserDefaults.standard.value(forKey: "profileImageURL") as! String,
            "post":self.msgTextView.text as Any,
            "postAttachmentURL":"",
            "timeStamp":timeStamp,
        ])
        
    }
    
    func getCurrentUserInfo() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        print("current user: %@", userID as Any)
        let queryRef = databaseReference.child("users")
        queryRef.child(userID as! String).observeSingleEvent(of: FIRDataEventType.value, with: {
            (snapshot) in
            print("Current User Info:\n", snapshot.value as! NSDictionary)
            queryRef.child(userID as! String + "/profilepic").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "profileImageURL")
                print("Profile Image URL", snapshot.value as Any)
            })
            queryRef.child(userID as! String + "/username").observe(FIRDataEventType.value, with: {
                (snapshot) in
                UserDefaults.standard.set(snapshot.value as Any, forKey: "profileUsername")
            })
        })
    }
    
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
    
    func setProfileUsername() {
        let profileUsername = UserDefaults.standard.value(forKey: "profileUsername") as! String
        welcomeUserLabel.text = "Welcome " + profileUsername + "!"
    }
    
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
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
