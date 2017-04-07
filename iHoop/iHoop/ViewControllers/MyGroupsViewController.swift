//
//  MyGroupsViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 4/5/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class MyGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //IBOutlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    //Create Group IBoutlets
    @IBOutlet weak var createGroupView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
