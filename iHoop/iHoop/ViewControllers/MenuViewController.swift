//
//  MenuViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MenuViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let profileImageClass = ProfileImageView()
    var databaseReference = FIRDatabaseReference.init()
    
    var menuImages:Array = [UIImage]()
    var menuNames:Array = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.synchronize()
        
        setProfilePic()
        setProfileUsername()
        
        profileImageClass.setProfileImageDesign(profileImageView)
        
        menuImages = [
            UIImage(named:"homeBtn")!,
            UIImage(named:"friendsBtn")!,
            UIImage(named:"myGroupsBtn")!,
            UIImage(named:"addGymBtn")!,
            UIImage(named:"settingsBtn")!,
            UIImage(named:"loginBtn")!
        ]
        menuNames = ["Home", "Friends", "My Groups","Add A Gym","Settings","Logout"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MenuCell
        
        cell.cellImageView.image = menuImages[indexPath.row]
        cell.cellNameLabel.text! = menuNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if cell.cellNameLabel.text! == "Home" {
            print("Home Tapped")
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            newFrontController.navigationBar.isHidden = true
            
        } else if cell.cellNameLabel.text! == "Friends" {
            print("Friends Tapped")
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            newFrontController.navigationBar.isHidden = true
            
        } else if cell.cellNameLabel.text! == "My Groups" {
            print("My Groups Tapped")
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MyGroupsViewController") as! MyGroupsViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            newFrontController.navigationBar.isHidden = true
        } else if cell.cellNameLabel.text! == "Add A Gym" {
            print("Add A Gym Tapped")
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "AddAGymController") as! AddAGymController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            newFrontController.navigationBar.isHidden = true
          
            
        } else if cell.cellNameLabel.text! == "Settings" {
            
            print("Settings Tapped")
            
        } else if cell.cellNameLabel.text! == "Logout" {
            print("Logout Tapped")
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    try FIRAuth.auth()?.signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                    print("User successfully logged out")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    /*
     * @IBAction - selectProfileImage
       Opens UIImagePickerController to select new profile pic
     */
    @IBAction func selectProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion:nil)
    }
    
    /*
     * setProfilePic
       Sets Profile Pic for user
     */
    func setProfilePic() {
        let profileImageURL = UserDefaults.standard.value(forKey: "profileImageURL")
        
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL:profileImageURL as! String)
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.profileImageView.image = image
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
            saveProfileToFirebaseStorage()
        }else{
            print("Error. Could not load image")
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setProfileUsername() {
        let profileUsername = UserDefaults.standard.value(forKey: "profileUsername") as! String
        usernameLabel.text = profileUsername
    }
    
    func saveProfileToFirebaseStorage() {
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference()
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = profileImageView.image?.jpeg(.lowest) {
            
            storedImage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        let userID = UserDefaults.standard.value(forKey: "currentUserUID")
                        self.databaseReference.child("users").child(userID as! String).updateChildValues(["profilepic": urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                        })
                    }
                })// end storageImage.downloadURL
                
            })// end storageImage.put
        } // end if let uploadData
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
