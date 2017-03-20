//
//  LoginTextField.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    /*
     * UITextField: Style
     */
    func setTextFieldDesign(textField: UITextField, placeHolderString: String) {
        let font = UIFont(name: "Bodoni 72 Smallcaps", size: 24)!
        let attributes = [
            NSForegroundColorAttributeName: orangeColor,
            NSFontAttributeName : font
        ]
        textField.layer.cornerRadius = 8
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.textColor = orangeColor
        textField.font = font
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes: attributes)
    }
    
    /*
     * UITextField: Error Style
     */
    func setErrorTextField(textField: UITextField, borderWidth: CGFloat) {
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = orangeColor.cgColor
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = orangeColor.cgColor
    }
    
    func resetTextField(textField: UITextField) {
        textField.text = ""
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
