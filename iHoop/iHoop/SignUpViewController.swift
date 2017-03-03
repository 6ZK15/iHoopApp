//
//  SignUpViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class SignUpViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fnTextField: UITextField!
    @IBOutlet var lnTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usrnmTextField: UITextField!
    @IBOutlet var pswdTextField: UITextField!
    @IBOutlet var vpswdTextField: UITextField!
    @IBOutlet var sqTextField: UITextField!
    @IBOutlet var saTextField: UITextField!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backBtn .addTarget(self, action:#selector(backBtnPressed), for: UIControlEvents.touchUpInside)
        let backButton:UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        self.setTextFieldAttributes(textField: self.fnTextField)
        self.setTextFieldAttributes(textField: self.lnTextField)
        self.setTextFieldAttributes(textField: self.emailTextField)
        self.setTextFieldAttributes(textField: self.usrnmTextField)
        self.setTextFieldAttributes(textField: self.pswdTextField)
        self.setTextFieldAttributes(textField: self.vpswdTextField)
        self.setTextFieldAttributes(textField: self.sqTextField)
        self.setTextFieldAttributes(textField: self.saTextField)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentInset.bottom = 106
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldAttributes(textField: UITextField) {
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 4.0
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func backBtnPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if (fnTextField.text?.isEmpty)!{
            self.label.isHidden = false
            self.label.text = "Please enter a first name."
        }else if(lnTextField.text?.isEmpty)!{
            self.label.isHidden = false
            self.label.text = "Please enter a last name"
        }
        else if(emailTextField.text?.isEmpty)!{
            self.label.isHidden = false
            self.label.text = "Please enter an email"
        }
        else if(usrnmTextField.text?.isEmpty)!{
            self.label.text = "Please enter an username"
        }
        else if(pswdTextField.text?.isEmpty)!{
            self.label.text = "Please enter a password"
        }
        else if (pswdTextField.text != vpswdTextField.text){
            self.label.text = "Passwords are not identical"
            }
        else{
        
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pswdTextField.text!, completion: {user,error
            in
            if let error = error {
                print(error)
            }else{
                self.ref.child("users").child(user!.uid).setValue([
                    "firstname":self.fnTextField.text,
                    "lastname:":self.lnTextField.text,
                    "email":self.emailTextField.text,
                    "username":self.usrnmTextField.text,
                    "password":self.pswdTextField.text
                ])
            }
        })
            let alertController = UIAlertController(title: "Sign Up", message: "User added successfully", preferredStyle: .alert)
            let defaultaction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultaction)
        self.present(alertController,animated:true,completion:nil)
            
            
    }
      

        
    }//end func
        
    




}//End Classs



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


