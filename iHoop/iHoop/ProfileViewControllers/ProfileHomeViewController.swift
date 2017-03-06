//
//  ProfileHomeViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ProfileHomeViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuBarBtn:UIBarButtonItem = UIBarButtonItem.init(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = menuBarBtn
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 0.000, green: 0.682, blue: 0.937, alpha: 1.000)
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuBtn .addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
//            menuBarBtn.target = revealViewController()
//            menuBarBtn.action = "revealToggle:"
            
            //            revealViewController().rightViewRevealWidth = 150
            //            extraButton.target = revealViewController()
            //            extraButton.action = "rightRevealToggle:"
            
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
