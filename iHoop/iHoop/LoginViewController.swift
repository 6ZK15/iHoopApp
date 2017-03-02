//
//  LoginViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var errorLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButton(_ sender: Any) {
        if let email = emailText.text, let pwd = passwordText.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil {
                    print("User Authenticated successfully")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil {
                            print("Unable to authenticate using Email with Firebase")
                            
                            if (self.emailText.text?.isEmpty)! , (self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter email and password"
                                self.emailText.layer.cornerRadius = 8.0
                                self.emailText.layer.borderWidth = 4.0
                                self.emailText.layer.borderColor = UIColor.black.cgColor
//                                self.emailText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                                self.passwordText.layer.cornerRadius = 8.0
                                self.passwordText.layer.borderWidth = 4.0
                                self.passwordText.layer.borderColor = UIColor.black.cgColor
//                                self.passwordText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                            } else if (self.emailText.text?.isEmpty)! , !(self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter email"
                                self.emailText.layer.cornerRadius = 8.0
                                self.emailText.layer.borderWidth = 4.0
                                self.emailText.layer.borderColor = UIColor.black.cgColor
//                                self.emailText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                            } else if !(self.emailText.text?.isEmpty)! , (self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter password"
                                self.passwordText.layer.cornerRadius = 8.0
                                self.passwordText.layer.borderWidth = 4.0
                                self.passwordText.layer.borderColor = UIColor.black.cgColor
//                                self.passwordText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                            } else {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Incorrect email and password"
                            }
                            
                        } else {
                            print("Successfully authenticated with Firebase")
                        }
                    })
                }
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
