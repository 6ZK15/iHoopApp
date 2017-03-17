//
//  HomeViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var arrowBtnB: UIButton!
    @IBOutlet weak var disableView: UIView!
    
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setTextFieldDesign()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * UITextField: Style
     */
    func setTextFieldDesign() {
        let font = UIFont(name: "Playball", size: 24)!
        let attributes = [
            NSForegroundColorAttributeName: orangeColor,
            NSFontAttributeName : font
        ]
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.borderStyle = UITextBorderStyle.roundedRect
        usernameTextField.textColor = orangeColor
        usernameTextField.font = font
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: attributes)
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField.textColor = orangeColor
        passwordTextField.font = font
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
    }
    
    /*
     * UIView: Animation to show and hide errorMessageView
     */
    func showHideErrorMessageView() {
        UIView.animate(withDuration: 1, animations: {
            self.errorMessageView.transform = CGAffineTransform.init(translationX: 0, y: 108)
            self.disableView.alpha = 0.25
        }) {(true) in
            UIView.animate(withDuration: 2, delay: 2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.errorMessageView.transform = CGAffineTransform.init(translationX: 0, y: -108)
                self.disableView.alpha = 0
            })
        }
    }
    
    /*
     * UIButton: Action associated with submitBtn
     * Check user login credentials (email and login)
     */
    func showHideMenuView() {
        if arrowBtn.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = CGAffineTransform.init(translationX: 0, y: 380)
                self.arrowBtn.alpha = 0
                self.arrowBtnB.alpha = 1
                self.arrowBtnB.transform = CGAffineTransform.init(rotationAngle: self.radians(180))
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = .identity
                self.arrowBtn.alpha = 1
                self.arrowBtnB.alpha = 0
                
            })
        }
    }
    
    /*
     * UIButton: Action associated with submitBtn
     * Check user login credentials (email and login)
     */
    @IBAction func submitBtn(_ sender: Any) {
        
        if let email = usernameTextField.text, let pwd = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                (user, error) in
                if error == nil {
                    print("User Authenticated successfully")
                    self.usernameTextField.layer.borderWidth = 0
                    self.passwordTextField.layer.borderWidth = 0
                    print("%@", user?.email  as Any)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                        (user, error) in
                        if error != nil {
                            print("Unable to authenticate using Email with Firebase")
                            if self.usernameTextField.text == "", self.passwordTextField.text == "" {
                                self.errorLabel.text = "Please fill out the required fields."
                                self.usernameTextField.layer.borderWidth = 2
                                self.usernameTextField.layer.borderColor = self.orangeColor.cgColor
                                self.passwordTextField.layer.borderWidth = 2
                                self.passwordTextField.layer.borderColor = self.orangeColor.cgColor
                                self.showHideErrorMessageView()
                            } else if self.usernameTextField.text == "" {
                                self.errorLabel.text = "Please enter username."
                                self.usernameTextField.layer.borderWidth = 2
                                self.usernameTextField.layer.borderColor = self.orangeColor.cgColor
                                self.passwordTextField.layer.borderWidth = 0
                                self.showHideErrorMessageView()
                            } else if self.passwordTextField.text == "" {
                                self.errorLabel.text = "Please enter password."
                                self.usernameTextField.layer.borderWidth = 0
                                self.passwordTextField.layer.borderWidth = 2
                                self.passwordTextField.layer.borderColor = self.orangeColor.cgColor
                                self.showHideErrorMessageView()
                            } else {
                                self.errorLabel.text = "Incorrect username and password. Please try again."
                                self.usernameTextField.layer.borderWidth = 2
                                self.usernameTextField.layer.borderColor = self.orangeColor.cgColor
                                self.passwordTextField.layer.borderWidth = 2
                                self.passwordTextField.layer.borderColor = self.orangeColor.cgColor
                                self.showHideErrorMessageView()
                            }
                        }
                    })
                }
            })
        }
    }
    
    /*
     * UIButton: Action associated with arrowBtn
     * Show menu options for sign up, sign in w/ facbook, forgot username, and forgort password
     */
    @IBAction func dropMenu(_ sender: Any) {
        showHideMenuView()
    }
    
    @IBAction func closeDropMenu(_ sender: Any) {
        
    }
    
    
    func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    
}

