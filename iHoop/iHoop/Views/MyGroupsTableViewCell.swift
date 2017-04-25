//
//  MyGroupsTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupPic: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupLocation: UILabel!
    @IBOutlet weak var groupNotifications: UILabel!
    @IBOutlet weak var lockedGroupImage: UIImageView!
    
    var groups: Groups!
    
    let databaseReference = FIRDatabase.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ group: Groups) {
        self.groups = group
        
        groupName.text = groups.groupName
        groupLocation.text = groups.groupLocation
    }
    
    func lockedGroup(_ group: Groups) {
        if group.locked {
            lockedGroupImage.alpha = 1.0
        } else {
            lockedGroupImage.alpha = 0.0
        }
    }

}
