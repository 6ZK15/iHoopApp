//
//  SignUpView.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/17/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class SignUpView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    @IBOutlet weak var securityQuestionTextField: UITextField!
    @IBOutlet weak var securityAniswerTextField: UITextField!
    
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    func setTextFieldDesign(textField: UITextField) {
        let font = UIFont(name: "Bodoni 72 Smallcaps", size: 24)!
        let attributes = [
            NSForegroundColorAttributeName: orangeColor,
            NSFontAttributeName : font
        ]
        firstNameTextField.layer.cornerRadius = 8
        firstNameTextField.borderStyle = UITextBorderStyle.roundedRect
        firstNameTextField.textColor = orangeColor
        firstNameTextField.font = font
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: attributes)
        lastNameTextField.layer.cornerRadius = 8
        lastNameTextField.borderStyle = UITextBorderStyle.roundedRect
        lastNameTextField.textColor = orangeColor
        lastNameTextField.font = font
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: attributes)
        emailTextField.layer.cornerRadius = 8
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.textColor = orangeColor
        emailTextField.font = font
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
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
        verifyPasswordTextField.layer.cornerRadius = 8
        verifyPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        verifyPasswordTextField.textColor = orangeColor
        verifyPasswordTextField.font = font
        verifyPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Verify Password", attributes: attributes)
        securityQuestionTextField.layer.cornerRadius = 8
        securityQuestionTextField.borderStyle = UITextBorderStyle.roundedRect
        securityQuestionTextField.textColor = orangeColor
        securityQuestionTextField.font = font
        securityQuestionTextField.attributedPlaceholder = NSAttributedString(string: "Security Question", attributes: attributes)
        securityAniswerTextField.layer.cornerRadius = 8
        securityAniswerTextField.borderStyle = UITextBorderStyle.roundedRect
        securityAniswerTextField.textColor = orangeColor
        securityAniswerTextField.font = font
        securityAniswerTextField.attributedPlaceholder = NSAttributedString(string: "Security Answer", attributes: attributes)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
