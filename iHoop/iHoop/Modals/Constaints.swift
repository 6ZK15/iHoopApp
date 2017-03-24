//
//  Constraints.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/23/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class Constraints: NSObject {
    
    let mainScreenHeight = UIScreen.main.bounds.size.height
    let mainScreenWidth = UIScreen.main.bounds.size.width
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    func adjustLoginTopMenuButton(_ menuBtn: UIButton) {
        
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
    
    func adjustProfileImageView(_ profileImage: UIImageView, _ setProfileBtn: UIButton) {
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = orangeColor.cgColor
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
            
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            setProfileBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.size.width/2 - 52, y: 106)
            setProfileBtn.translatesAutoresizingMaskIntoConstraints = true
            setProfileBtn.updateConstraints()
            profileImage.frame.origin = CGPoint.init(x: UIScreen.main.bounds.size.width/2 - 85, y: 0)
            profileImage.translatesAutoresizingMaskIntoConstraints = true
            profileImage.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            
        }
    }
    
    func adjustSetProfileImageSubmitBtn(_ submitBtn: UIButton) {
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
        
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            submitBtn.frame.origin = CGPoint.init(x: UIScreen.main.bounds.size.width/2 - 5, y: 260)
            submitBtn.translatesAutoresizingMaskIntoConstraints = true
            submitBtn.updateConstraints()
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
        
        }
    }
    
    func adjustForgotEmailSubmitButton(_ submitBtn: UIButton) {
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
            
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")

        }
    }
    
    func adjustRememberSwitch(_ switch: UISwitch) {
        
        if ((mainScreenHeight == 736) && (mainScreenWidth == 414)) {
            print("iPhone 6/7 Plus")
            
        } else if ((mainScreenHeight == 667) && (mainScreenWidth == 375)) {
            print("iPhone 6/7")
            
        } else if ((mainScreenHeight == 568) && (mainScreenWidth == 320)) {
            print("iPhone 5/SE")
            
        }
    }

}
