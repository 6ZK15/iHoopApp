//
//  ProfileHomeViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/6/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ProfileHomeViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var menuBtn: UIButton!
    
    var pageViewController: UIPageViewController!
    var index = 0
    var identifiers: NSArray = ["NewsFeedViewController", "NotificationsViewController", "SearchViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuBarBtn:UIBarButtonItem = UIBarButtonItem.init(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = menuBarBtn
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 0.000, green: 0.682, blue: 0.937, alpha: 1.000)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PagingViewController") as! UIPageViewController!
        self.pageViewController.dataSource = self
        
        let startingViewController: NewsFeedViewController = self.viewControllerAtIndex(index: self.index) as! NewsFeedViewController
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
        
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
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            
            self.title = "Home"
            return self.storyboard!.instantiateViewController(withIdentifier: "NewsFeedViewController") as UIViewController
            
        }
        
        //second view controller = secondViewController's navigation controller
        if index == 1 {
            
            self.title = "Notifications"
            return self.storyboard!.instantiateViewController(withIdentifier: "NotificationsViewController") as UIViewController
        }
        
        //third view controller = thirdViewController's navigation controller
        if index == 2 {
            
            self.title = "Search"
            return self.storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as UIViewController
            
        }
        
        return nil
    }
    
    /*
     Subscribe and come to the shop to get a free sample at Grand Opening
     Combo package
     Print labels
     
     Books to Read:
     Four Agreement
     Fifth Agreement
     The Richest Salesman in the World
     */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            if index == self.identifiers.index(of: identifier) {
                if index < identifiers.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: identifiers[index + 1] as! String)
                }
            }
        }
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            if index == identifiers.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: identifiers[index - 1] as! String)
                }
            }
        }
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
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
