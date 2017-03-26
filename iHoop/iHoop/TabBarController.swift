//
//  TabBarController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/25/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background Image
        let bgView: UIImageView = UIImageView(image: UIImage(named: "tabBar@2x.png"))
        bgView.frame = CGRect.init(x: 0,
                                   y: UIScreen.main.bounds.height - 50,
                                   width: UIScreen.main.bounds.width,
                                   height: 50)
        view.addSubview(bgView)
        
        //TabBarItem Font
        let attributes = [
            NSFontAttributeName : UIFont(name: "Playball", size: 10)!
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: UIControlState.normal)
        
        // Do any additional setup after loading the view.
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
