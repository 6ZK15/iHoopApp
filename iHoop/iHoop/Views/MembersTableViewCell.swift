//
//  MembersTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var friends: Friends!
    let profileImageClass = ProfileImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageClass.setProfileImageDesign(profileImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ friends: Friends) {
        profileImageClass.setProfileImageDesign(profileImageView)
        username.text = friends.username
    }

}
