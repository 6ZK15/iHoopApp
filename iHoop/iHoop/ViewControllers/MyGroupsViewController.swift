//
//  MyGroupsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //IBOutlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    //Create Group IBoutlets
    @IBOutlet weak var createGroupView: UIView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupImageScrollView: UIScrollView!
    @IBOutlet weak var groupPrivacySegControl: UISegmentedControl!
    
    var groups = [Groups]()
    let textFieldClass = TextField()
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroupsForUser()
        textFieldClass.setTextFieldDesign(textField: groupNameTextField, placeHolderString: "Name of Group")
        
        if revealViewController() != nil {
            menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderTitles = ["Public","Private"]
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = UIColor.darkGray
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 8, y: 8, width: tableView.frame.size.width - 8, height: 22))
        titleLabel.textColor = orangeColor
        titleLabel.font = UIFont.init(name: "Bodoni 72 Smallcaps", size: 24)
        titleLabel.text = sectionHeaderTitles[section]
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MyGroupsTableViewCell
        let group = groups[indexPath.row]
        
        cell.configureCell(group)
        
        return cell
    }
    
    @IBAction func addGroup(_ sender: Any) {
        print("Add Group button pressed")
        showHideCreateGroup()
    }
    
    @IBAction func cancelCreateGroup(_ sender: Any) {
        print("Cancel Group button pressed")
        showHideCreateGroup()
    }
    
    @IBAction func createGroup(_ sender: Any) {
        storeGroupInfo()
        textFieldClass.resetTextField(textField: groupNameTextField)
        showHideCreateGroup()
    }
    
    func showHideCreateGroup() {
        if createGroupView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 1, animations: {
                self.gradientView.alpha = 0.7
                self.createGroupView.transform = CGAffineTransform.init(translationX: 0, y: -389)
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.gradientView.alpha = 0
                self.createGroupView.transform = CGAffineTransform.identity
            })
        }
    }
    
    func storeGroupInfo() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        let groupName = groupNameTextField.text
        
        // Store Private Group Info
        if groupPrivacySegControl.selectedSegmentIndex == 0 {
            databaseReference.child("users").child(userID as! String).child("groups").child(NSUUID().uuidString).setValue([
                "groupName": groupName,
                "groupPrivacy": "private",
                "groupLocation": "nothing as of now",
                "groupPic": "nothing as of now"
                ])
            groupPrivacySegControl.selectedSegmentIndex = -1
        }
            
        // Store Public Group Info
        else if groupPrivacySegControl.selectedSegmentIndex == 1 {
            databaseReference.child("groups").child(NSUUID().uuidString).setValue([
                "groupName": groupName,
                "groupPrivacy": "public",
                "groupLocation": "nothing as of now",
                "groupPic": "nothing as of now"
            ])
            groupPrivacySegControl.selectedSegmentIndex = -1
        }
    }
    
    /*
     * getGroupsForUser
     Retrieves the user's group information
     */
    func getGroupsForUser() {
        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
        // Get Public Groups
        databaseReference.child("groups").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.groups = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let groupDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let group = Groups(key: key, dictionary: groupDictionary)
                        self.groups.insert(group, at: 0)
                    }
                }
            }
            self.groupsTableView.reloadData()
        })
        
        // Get Private Groups
        databaseReference.child("users").child(userID as! String).child("groups").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.groups = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let groupDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let group = Groups(key: key, dictionary: groupDictionary)
                        self.groups.insert(group, at: 0)
                    }
                }
            }
            self.groupsTableView.reloadData()
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
