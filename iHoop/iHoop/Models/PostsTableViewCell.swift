//
//  PostsTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/24/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var postMessageLabel: UILabel!
    @IBOutlet weak var attachmentLinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
