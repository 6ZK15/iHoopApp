//
//  LoginViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var errorLbl: UILabel!
    @IBOutlet var backBtn: UIButton!
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn .addTarget(self, action:#selector(backBtnPressed), for: UIControlEvents.touchUpInside)
        let backButton:UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        self .clearLogin()
     
        
        
        
       // if let _ = KeychainWrapper.string(KEY_UID){
           // performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        //}
        
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
                    print("User email Authenticated successfully")
                    if let user = user{
                        self.completeSignIn(id: user.uid)
                    }
                    self.performSegue(withIdentifier:"ProfileHomeViewController", sender: nil)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil {
                            print("Unable to authenticate using Email with Firebase")
                            
                            if (self.emailText.text?.isEmpty)! , (self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter email and password"
                                self.emailText.layer.cornerRadius = 8.0
                                self.emailText.layer.borderWidth = 4.0
                                self.emailText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                                self.passwordText.layer.cornerRadius = 8.0
                                self.passwordText.layer.borderWidth = 4.0
                                self.passwordText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                            } else if (self.emailText.text?.isEmpty)! , !(self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter email"
                                self.emailText.layer.cornerRadius = 8.0
                                self.emailText.layer.borderWidth = 4.0
                                self.emailText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                                self.passwordText.layer.borderColor = UIColor.black.cgColor
                            } else if !(self.emailText.text?.isEmpty)! , (self.passwordText.text?.isEmpty)! {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Please enter password"
                                self.passwordText.layer.cornerRadius = 8.0
                                self.passwordText.layer.borderWidth = 4.0
                                self.passwordText.layer.borderColor = UIColor.init(red: 0.000, green: 0.682, blue: 0.937, alpha: 1.000).cgColor
                                self.emailText.layer.borderColor = UIColor.black.cgColor
                            } else {
                                self.errorLbl.isHidden = false
                                self.errorLbl.text = "Incorrect email and password"
                                self.emailText.layer.borderColor = UIColor.black.cgColor
                                self.passwordText.layer.borderColor = UIColor.black.cgColor
                            }
                            
                        } else {
                            print("Successfully created authenticated user with Firebase")
                            if let user = user{
                                self.completeSignIn(id: user.uid)
                            }
                            self.performSegue(withIdentifier:"ProfileHomeViewController", sender: nil)
                       
                            
                        }
                    })
                }
            })
            
        }
        
        

    }
    
    func firebaseAuth(_ credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate using Email with Firebase - \(error)")
            }else{
                print("User authenticated with Firebase Successfully ")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
                

        })
    }
    
    func clearLogin() {
        emailText.layer.cornerRadius = 8.0
        emailText.layer.borderWidth = 4.0
        emailText.layer.borderColor = UIColor.black.cgColor
        passwordText.layer.cornerRadius = 8.0
        passwordText.layer.borderWidth = 4.0
        passwordText.layer.borderColor = UIColor.black.cgColor
    }
    
    func completeSignIn(id:String){
        let keychainResult = KeychainWrapper.standard.string(forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
    }
    
    func backBtnPressed() {
        _ = self.navigationController?.popViewController(animated: true)
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
