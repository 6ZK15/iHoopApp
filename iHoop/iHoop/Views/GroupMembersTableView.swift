//
//  GroupMembersTableView.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/26/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class GroupMembersTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCell(withIdentifier: "memberCellIdentifier", for: indexPath)
        
        return cell
    }

}
