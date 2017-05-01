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
    var publicGroups = [Groups]()
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
        headerView.backgroundColor = UIColor.clear
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 8, y: 8, width: tableView.frame.size.width - 8, height: 22))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.init(name: UIFontTextStyle.title2.rawValue, size: 24)
        titleLabel.text = sectionHeaderTitles[section]
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return publicGroups.count
        } else {
            return groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyGroupsTableViewCell()
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MyGroupsTableViewCell
            let group = publicGroups[indexPath.row]
            print("This group is locked: ", group.locked)
            cell.lockedGroup(group)
            cell.configureCell(group)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifierTwo", for: indexPath) as! MyGroupsTableViewCell
            let group = groups[indexPath.row]
            cell.configureCell(group)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupSegue", sender: indexPath)
        
        if indexPath.section == 0 {
            let group = publicGroups[indexPath.row]
            UserDefaults.standard.set(group.groupName, forKey: "groupName")
            UserDefaults.standard.set(group.locked, forKey: "groupLocked")
            UserDefaults.standard.set(group.groupPrivacy, forKey: "groupPrivacy")
            UserDefaults.standard.set(group.groupLocation, forKey: "groupLocation")
            print("Group Privacy: ", group.groupPrivacy)
            print("Group Name: ", group.groupName)
            print("Group Locked: ", group.locked)
            
            if !group.locked {
                UserDefaults.standard.set(group.key, forKey: "groupID")
                print("Group Key:", group.key)
            }
        } else {
            let group = groups[indexPath.row]
            UserDefaults.standard.set(group.groupName, forKey: "groupName")
            UserDefaults.standard.set(group.locked, forKey: "groupLocked")
            UserDefaults.standard.set(group.groupPrivacy, forKey: "groupPrivacy")
            UserDefaults.standard.set(group.groupLocation, forKey: "groupLocation")
            print("Group Privacy: ", group.groupPrivacy)
            UserDefaults.standard.set(group.key, forKey: "groupID")
            print("Group Name: ", group.groupName)
            print("Group Key:", group.key)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var bool = Bool()
        if indexPath.section == 0 {
            if publicGroups[indexPath.row].locked {
                bool = false
            } else {
                bool = true
            }
        } else {
            bool =  true
        }
        
        return bool
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal,
                                        title: "Edit",
                                        handler: {
                                            (action, index) in
                                            print("Repost Button Tapped")
        })
        edit.backgroundColor = orangeColor
        
        return [edit]
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
        guard let userID = UserDefaults.standard.value(forKey: "currentUserUID") else { return }
        let groupName = groupNameTextField.text
        
        // Store Private Group Info
        if groupPrivacySegControl.selectedSegmentIndex == 0 {
            databaseReference.child("users").child(userID as! String).child("groups").child("private").child(NSUUID().uuidString).setValue([
                "groupName": groupName!,
                "groupPrivacy": "private",
                "groupLocation": "nothing as of now",
                "groupPic": "nothing as of now",
                "locked": false
            ])
            groupPrivacySegControl.selectedSegmentIndex = -1
        }
            
        // Store Public Group Info
        else if groupPrivacySegControl.selectedSegmentIndex == 1 {
            databaseReference.child("groups").child(NSUUID().uuidString).setValue([
                "groupName": groupName!,
                "groupPrivacy": "public",
                "groupLocation": "nothing as of now",
                "groupPic": "nothing as of now",
                "locked": false
            ])
            
            databaseReference.child("users").child(userID as! String).child("groups").child("public").child(NSUUID().uuidString).setValue([
                "groupName": groupName!,
                "groupPrivacy": "public",
                "groupLocation": "nothing as of now",
                "groupPic": "nothing as of now",
                "locked": false
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
        databaseReference.child("users").child(userID as! String).child("groups").child("public").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.publicGroups = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let groupDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let group = Groups(key: key, dictionary: groupDictionary)
                        self.publicGroups.insert(group, at: 0)
                    }
                }
            }
            self.groupsTableView.reloadData()
        })
        
        databaseReference.child("users").child(userID as! String).child("groups").child("public").observe(FIRDataEventType.value, with: {
            (snapshot) in
            
            self.publicGroups = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    if let groupDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let group = Groups(key: key, dictionary: groupDictionary)
                        self.publicGroups.insert(group, at: 0)
                    }
                }
            }
            self.groupsTableView.reloadData()
        })
        
        // Get Private Groups
        databaseReference.child("users").child(userID as! String).child("groups").child("private").observe(FIRDataEventType.value, with: {
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
