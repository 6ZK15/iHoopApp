//
//  SignUpView.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/17/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    @IBOutlet weak var securityQuestionTextField: UITextField!
    @IBOutlet weak var securityAnswerTextField: UITextField!
    
    let databaseReference = FIRDatabase.database().reference()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func didMoveToWindow() {
        setTextFieldDesign()
    }
    
    func setTextFieldDesign() {
        
        let loginTextField = LoginTextField()
        
        loginTextField.setTextFieldDesign(textField: firstNameTextField, placeHolderString: "First Name")
        loginTextField.setTextFieldDesign(textField: lastNameTextField, placeHolderString: "Last Name")
        loginTextField.setTextFieldDesign(textField: emailTextField, placeHolderString: "Email")
        loginTextField.setTextFieldDesign(textField: usernameTextField, placeHolderString: "Username")
        loginTextField.setTextFieldDesign(textField: passwordTextField, placeHolderString: "Password")
        loginTextField.setTextFieldDesign(textField: verifyPasswordTextField, placeHolderString: "Verify Password")
        loginTextField.setTextFieldDesign(textField: securityQuestionTextField, placeHolderString: "Security Question")
        loginTextField.setTextFieldDesign(textField: securityAnswerTextField, placeHolderString: "Security Answer")
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
