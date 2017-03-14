
 
 //
//  SignUpViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let databseRef = FIRDatabase.database().reference()
    let storageref = FIRStorage.storage().reference()
    let imagePicker = UIImagePickerController()

  
    @IBOutlet var profilePicImageView: UIImageView!
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
        
        imagePicker.delegate = self
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
    
    func signUP() {
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: pswdTextField.text!, completion: {(user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let userReference = self.databseRef.child("users").child(uid)
            let values = ["firstname":self.fnTextField.text!,"lastname":self.lnTextField.text!, "email":self.emailTextField.text!, "username":self.usrnmTextField.text!, "password":self.pswdTextField.text!, "security question":self.sqTextField.text!,"security answer":self.saTextField.text!,"profilepic":"" ]
            userReference.updateChildValues(values, withCompletionBlock: { (error,ref) in
                if error != nil {
                    print(error!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        })
    }//end func sign up
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
           let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            profilePicImageView.contentMode = .scaleAspectFill
            profilePicImageView.image = pickedImage
        }
        
      
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }

    
    
    
    @IBAction func uploadPic(_ sender: Any) {
        
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion:nil)
        }
    
    @IBAction func signUpUser(_ sender: Any) {
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
                    self.databseRef.ref.child("users").child(user!.uid).setValue([
                        "firstname":self.fnTextField.text!,
                        "lastname":self.lnTextField.text!,
                        "email":self.emailTextField.text!,
                        "username":self.usrnmTextField.text!,
                        "password":self.pswdTextField.text!,
                        "securityQuestion":self.sqTextField.text!,
                        "securityAnswer":self.saTextField.text!,
                        "profilePic":""
                        ])
                }
            })
        }
        let alertController = UIAlertController(title: "Sign Up", message: "User added successfully", preferredStyle: .alert)
        let defaultaction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultaction)
        self.present(alertController,animated:true,completion:nil)
        
        
    }

  
}
   
    /*
    func saveChanges(){
        let imageName = NSUUID().uuidString
        let storedImage = storageref.child("profilepic").child(imageName)
 
        if let  uploadData = UIImagePNGRepresentation(self.profilePicImageView.image!)
        {
            storedImage.put(uploadData, metadata: nil, completion: { (metadata,error) in
                if error != nill {
                    print(error)
                    return
                }
                storedImage.downloadURL(completion: { (url,error) in
                    if error != nill {
                        print(error)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        self.databseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["profilepic":urlText], withCompletionBlock: {(error,ref) in
                            if error!=nil
                            {
                                print(error)
                                return
                            }
                        })
                    }
            })
                })
            }
        }
*/
                    
                
    
        
        
    


                

   



//End Classs



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


