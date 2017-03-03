//
//  ForgotPasswordViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/2/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var pswdLbl: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backBtn .addTarget(self, action:#selector(backBtnPressed), for: UIControlEvents.touchUpInside)
        let backButton:UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        self.setTextFieldAttributes(textField: self.emailTextField)
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
    
    @IBAction func forgotPasswordSubmit(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: {(error) in
            
            var title = ""
            var message = ""
            if error != nil
            {
                title = "Welp"
                message = (error?.localizedDescription)!
            }else{
                title = "Success"
                message = "Password reset has been sent"
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultaction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultaction)
            
            self.present(alertController,animated:true,completion:nil)
            
            
        })
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
