//
//  Constraints.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/23/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class Constraints: NSObject {
    
    func adjustLoginTopMenuButton(_ menuBtn: UIButton) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            menuBtn.frame.origin = CGPoint.init(x: 161, y: 116)
            menuBtn.translatesAutoresizingMaskIntoConstraints = true
            menuBtn.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            menuBtn.frame.origin = CGPoint.init(x: 141, y: 116)
            menuBtn.translatesAutoresizingMaskIntoConstraints = true
            menuBtn.updateConstraints()
        }
    }
    
    func adjustLoginBottomMenuButton(_ menuBtn: UIButton) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            menuBtn.frame.origin = CGPoint.init(x: 161, y: 449)
            menuBtn.translatesAutoresizingMaskIntoConstraints = true
            menuBtn.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            menuBtn.frame.origin = CGPoint.init(x: 141, y: 441)
            menuBtn.translatesAutoresizingMaskIntoConstraints = true
            menuBtn.updateConstraints()
        }
    }
    
    func adjustSubmitButton(_ submitBtn: UIButton) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            submitBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.size.width/2 - 40, y: 393)
            submitBtn.translatesAutoresizingMaskIntoConstraints = true
            submitBtn.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            submitBtn.frame.origin = CGPoint.init(x: 121, y: 369)
            submitBtn.translatesAutoresizingMaskIntoConstraints = true
            submitBtn.updateConstraints()
        }
    }
    
    func adjustSignUpSumbitButton(_ submitBtn: UIButton) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            submitBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.size.width/2 - 40, y: 404)
            submitBtn.translatesAutoresizingMaskIntoConstraints = true
            submitBtn.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            submitBtn.translatesAutoresizingMaskIntoConstraints = true
            submitBtn.updateConstraints()
        }
    }
    
    func adjustForgotEmailSubmitButton(_ submitBtn: UIButton) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
            
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            
        }
    }
    
    func adjustRememberSwitch(_ switch: UISwitch) {
        let mainScreenHeight = UIScreen.main.bounds.size.height
        let mainScreenWidth = UIScreen.main.bounds.size.width
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
            
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            
        }
    }

}
