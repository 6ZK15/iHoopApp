//
//  MenuViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var MenuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuNameArray = ["Home","My Groups","Find A Gym","Settings","Privacy","Sign Out"]
//        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!]
        
        imgProfile.layer.borderWidth = 4
        imgProfile.layer.borderColor = UIColor.init(red: 0.812, green: 0.337, blue: 0.157, alpha: 1.000).cgColor
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = MenuNameArray[indexPath.row]
//        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        if cell.lblMenuname.text! == "Home" {
            print("Home Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ProfileHomeViewController") as! ProfileHomeViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
//        if cell.lblMenuname.text! == "Message"
//        {
//            print("message Tapped")
//            
//            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
//            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
//            
//            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
//        }
        if cell.lblMenuname.text! == "Settings" {
            print("Map Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "Sign Out" {
            print("setting Tapped")
            _ = self.navigationController?.popViewController(animated: true)
        }
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
