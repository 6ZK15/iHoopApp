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
<<<<<<< HEAD
import FirebaseDatabase
=======
import FBSDKLoginKit
>>>>>>> f0b8bb17c03a6dfb1fa1a4b79b2f42160b686d7d

class HomeViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var arrowBtnB: UIButton!
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var menuOptionView: UIView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    
<<<<<<< HEAD
=======
    var signUpView: SignUpView?
    let facebookLogin = FacebookLogin()
>>>>>>> f0b8bb17c03a6dfb1fa1a4b79b2f42160b686d7d
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setTextFieldDesign()
        
    }
    
    override func viewDidLayoutSubviews() {
        signUpScrollView.isScrollEnabled = true
        signUpScrollView.contentSize = CGSize.init(width: view.frame.size.width, height: 660)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * UITextField: Style
     */
    func setTextFieldDesign() {
        let font = UIFont(name: "Bodoni 72 Smallcaps", size: 24)!
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
                self.menuOptionView.alpha = 1
                self.usernameTextField.alpha = 0
                self.passwordTextField.alpha = 0
                self.rememberLabel.alpha = 0
                self.rememberSwitch.alpha = 0
                self.submitBtn.alpha = 0
                self.signUpScrollView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = .identity
                self.arrowBtnB.alpha = 0
                self.arrowBtn.alpha = 1
                self.menuOptionView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.usernameTextField.alpha = 1
                    self.passwordTextField.alpha = 1
                    self.rememberLabel.alpha = 1
                    self.rememberSwitch.alpha = 1
                    self.submitBtn.alpha = 1
                })
            }
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
    
    @IBAction func submitSignUp(_ sender: Any) {
        let signUpView = SignUpView()
        showHideErrorMessageView()
        errorLabel.text = "User succesfully signed up"
        signUpView.submitSignUp()
    }
    
    
    /*
     * UIButton: Action associated with arrowBtn
     * Show menu options for sign up, sign in w/ facbook, forgot username, and forgort password
     */
    @IBAction func dropMenu(_ sender: Any) {
        showHideMenuView()
    }
    
    @IBAction func showLoginView(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.transform = .identity
            self.arrowBtnB.alpha = 0
            self.arrowBtn.alpha = 1
            self.menuOptionView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.usernameTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.rememberLabel.alpha = 1
                self.rememberSwitch.alpha = 1
                self.submitBtn.alpha = 1
            })
        }
    }
    
    @IBAction func showSignUpView(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.transform = .identity
            self.arrowBtnB.alpha = 0
            self.arrowBtn.alpha = 1
            self.menuOptionView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.signUpScrollView.alpha = 1
            })
        }
    }
    @IBAction func loginWithFacebbok(_ sender: UIButton) {
        facebookSignIn()
    }
    
    func facebookSignIn(){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            if error != nil {
                print("Unable to authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true{
                    print("User cancelled authentication with Facebook")
            }else{
                print("Successfully authenticaed with Facebook - \(error)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print("Unable to authenticate with firebase - \(error)")
            } else {
                print("Successfully authenticated with firebase")
            }
        })
    }
    
    /*
     * CGFloat: Degrees to Radians
     */
    func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    
}

