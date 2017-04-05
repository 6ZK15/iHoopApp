//
//  FriendsTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/30/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendsProfilePic: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    let profileImageClass = ProfileImageView()
    var friends: Friends!
    var buttonFunc: (() -> (Void))!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ friend: Friends) {
        self.friends = friend
        
//        setPostProfilePic()
        profileImageClass.setProfileImageDesign(friendsProfilePic)
        fullName.text = friends.firstname + " " + friends.lastname
        username.text = friends.username
    }

    func setPostProfilePic() {
        let profileImageURL = UserDefaults.standard.value(forKey: "profileImageURL")
        
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL:profileImageURL as! String)
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.friendsProfilePic.image = image
        }
    }
    
    @IBAction func addFriend(_ sender: Any) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }
    
}
