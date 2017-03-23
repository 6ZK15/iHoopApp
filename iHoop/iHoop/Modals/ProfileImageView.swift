//
//  ProfileImageView.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/22/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    func setProfileImageDesign(_ profileImageView: UIImageView) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
