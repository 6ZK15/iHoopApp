//
//  LoginViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        if let email = emailText.text, let pwd = passwordText.text
        {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil {
                    print("User Authenticated successfully")
                }else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil {
                            print("Unable to authenticate using Email with Firebase")
                        }else {
                            print("Successfully authenticated with Firebase")
                        }
                    })
                }
            })
            
        }
        
    }
}







