//
//  RequestTableViewCell.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/31/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestProfilePic: UIImageView!
    @IBOutlet weak var requestFullName: UILabel!
    @IBOutlet weak var requestUsername: UILabel!
    @IBOutlet weak var requestResponse: UISegmentedControl!
    

    let profileImageClass = ProfileImageView()
    var requests: Requests!
    var buttonFunc: (() -> (Void))!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ request: Requests) {
        self.requests = request
        
//        setPostProfilePic()
        profileImageClass.setProfileImageDesign(requestProfilePic)
        requestFullName.text = requests.fullname
        requestUsername.text = requests.username
    }
    
    func setPostProfilePic() {
        let profileImageURL = UserDefaults.standard.value(forKey: "profileImageURL")
        
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL:profileImageURL as! String)
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.requestProfilePic.image = image
        }
    }
    
    @IBAction func requestResponse(_ sender: Any) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }

}
