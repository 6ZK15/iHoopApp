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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var ltbTableView: UITableView!
    @IBOutlet weak var ltbButton: UIButton!
    @IBOutlet weak var ltbSubmitButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextField: UITextField!
    
    
    
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    
    let databaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentUserInfo()
        setProfilePic()
        
        profileImageClass.setProfileImageDesign(profileImage)
        textFieldClass.setProfileTextField(textField: msgTextField)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        
        return cell
    }
    
    @IBAction func letsTalkBballBtn(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.ltbTableView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
            self.messageView.transform = CGAffineTransform.init(translationX: 0, y: self.messageView.frame.height)
            self.ltbButton.alpha = 0
            self.messageView.alpha = 1
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
