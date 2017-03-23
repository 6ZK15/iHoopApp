//
//  ProfileViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/22/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var ltbTableView: UITableView!
    @IBOutlet weak var ltbButton: UIButton!
    @IBOutlet weak var ltbSubmitButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgTextField: UITextField!
    
    let profileImageClass = ProfileImageView()
    let textFieldClass = TextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
