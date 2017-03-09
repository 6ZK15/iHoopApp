//
//  PagingViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/7/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation
import UIKit

class PagingViewController: UIPageViewController, UIPageViewControllerDelegate {//, UIPageViewControllerDataSource {
    
//    var index = 0
//    var identifiers: NSArray = ["NewsFeedViewController", "SecondNavigationController"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func viewControllerAtIndex(index: Int) -> UINavigationController! {
//        
//        //first view controller = firstViewControllers navigation controller
//        if index == 0 {
//            
//            return self.storyboard!.instantiateViewController(withIdentifier: "FirstNavigationController") as! UINavigationController
//            
//        }
//        
//        //second view controller = secondViewController's navigation controller
//        if index == 1 {
//            
//            return self.storyboard!.instantiateViewController(withIdentifier: "SecondNavigationController") as! UINavigationController
//        }
//        
//        return nil
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        
//        let identifier = viewController.restorationIdentifier
//        let index = self.identifiers.index(of: identifier!)
//        
//        //if the index is the end of the array, return nil since we dont want a view controller after the last one
//        if index == identifiers.count - 1 {
//            
//            return nil
//        }
//        
//        //increment the index to get the viewController after the current index
//        self.index = self.index + 1
//        return self.viewControllerAtIndex(index: self.index)
//        
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController!, viewControllerBefore viewController: UIViewController!) -> UIViewController! {
//        
//        let identifier = viewController.restorationIdentifier
//        let index = self.identifiers.index(of: identifier!)
//        
//        //if the index is 0, return nil since we dont want a view controller before the first one
//        if index == 0 {
//            
//            return nil
//        }
//        
//        //decrement the index to get the viewController before the current one
//        self.index = self.index - 1
//        return self.viewControllerAtIndex(index: self.index)
//        
//    }
//    
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
//        return self.identifiers.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
//        return 0
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
