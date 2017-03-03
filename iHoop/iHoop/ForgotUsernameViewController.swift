//
//  ForgotUsernameViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 3/2/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class ForgotUsernameViewController: UIViewController {

    @IBOutlet var usrnmeLbl: UILabel!
    @IBOutlet var sqTextField: UITextField!
    @IBOutlet var saTextField: UITextField!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backBtn .addTarget(self, action:#selector(backBtnPressed), for: UIControlEvents.touchUpInside)
        let backButton:UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        self.setTextFieldAttributes(textField: self.sqTextField)
        self.setTextFieldAttributes(textField: self.saTextField)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}