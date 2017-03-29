//
//  PostsTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/24/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var postMessageLabel: UILabel!
    @IBOutlet weak var attachmentLinkLabel: UILabel!
    
    let profileImageClass = ProfileImageView()
    var posts: Posts!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ post: Posts) {
        self.posts = post
        
//        setPostProfilePic()
        postMessageLabel.text = posts.postMessage
        timeStampLabel.text = posts.postTimeStamp
    }
    
    func setPostProfilePic() {
        let profileImageURL = UserDefaults.standard.value(forKey: "profileImageURL")
        
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL:profileImageURL as! String)
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.postProfileImage.image = image
        }
        profileImageClass.setProfileImageDesign(postProfileImage)
    }

}
