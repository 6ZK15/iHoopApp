//
//  GroupViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/23/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupViewController: UIViewController {
    
    @IBOutlet weak var groupName: UILabel!
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupName.text = UserDefaults.standard.value(forKey: "groupName") as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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
