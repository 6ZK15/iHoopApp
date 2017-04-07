//
//  MyGroupsTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupPic: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupLocation: UILabel!
    @IBOutlet weak var groupNotifications: UILabel!
    
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        
    }

}
