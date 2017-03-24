//
//  HomeViewController.swift
//  iHoop
//
//  Created by Nehemiah Horace on 2/27/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class HomeViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Sign Up Outlets
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var sufirstNameTextField: UITextField!
    @IBOutlet weak var sulastNameTextField: UITextField!
    @IBOutlet weak var suemailTextField: UITextField!
    @IBOutlet weak var suusernameTextField: UITextField!
    @IBOutlet weak var supasswordTextField: UITextField!
    @IBOutlet weak var suverifyPasswordTextField: UITextField!
    @IBOutlet weak var submitSignUpBtn: UIButton!
    
    //Profile Image Outlet
    @IBOutlet weak var setProfileImageView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var submitProfileImageBtn: UIButton!
    
    //Forgot Password Outlets
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var fpemailTextField: UITextField!
    @IBOutlet weak var submitForgotPasswordBtn: UIButton!
    
    //Forgot Email Outlets
    @IBOutlet weak var forgotEmailView: UIView!
    @IBOutlet weak var fefirstNameTextField: UITextField!
    @IBOutlet weak var felastNameTextField: UITextField!
    @IBOutlet weak var feusernameTextField: UITextField!
    @IBOutlet weak var submitForgotEmailBtn: UIButton!
    
    //Login Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var arrowBtnB: UIButton!
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var menuOptionView: UIView!
    
    
    var databaseReference = FIRDatabaseReference.init()
    let facebookLogin = FacebookLogin()
    let textField = TextField()
    let constraintsClass = Constraints()
    let orangeColor = UIColor.init(red: 0.796, green: 0.345, blue: 0.090, alpha: 1.000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textField.setTextFieldDesign(textField: usernameTextField, placeHolderString: "Username (Email)")
        textField.setTextFieldDesign(textField: passwordTextField, placeHolderString: "Password")
        textField.setTextFieldDesign(textField: fpemailTextField, placeHolderString: "Email")
        textField.setTextFieldDesign(textField: fefirstNameTextField, placeHolderString: "First Name")
        textField.setTextFieldDesign(textField: felastNameTextField, placeHolderString: "Last Name")
        textField.setTextFieldDesign(textField: feusernameTextField, placeHolderString: "Username")
        
        constraintsClass.adjustLoginTopMenuButton(arrowBtn)
        constraintsClass.adjustLoginBottomMenuButton(arrowBtnB)
        constraintsClass.adjustSubmitButton(submitBtn)
        constraintsClass.adjustSignUpSumbitButton(submitSignUpBtn)
        constraintsClass.adjustSetProfileImageSubmitBtn(submitProfileImageBtn)
        constraintsClass.adjustProfileImageView(profileImageView, chooseImageBtn)
        constraintsClass.adjustForgotEmailSubmitButton(submitForgotEmailBtn)
        constraintsClass.adjustForgotPasswordSubmitButton(submitForgotPasswordBtn)
        constraintsClass.adjustMenuOptionView(menuOptionView)
    }
    
    override func viewDidLayoutSubviews() {
        signUpScrollView.isScrollEnabled = true
        signUpScrollView.contentSize = CGSize.init(width: view.frame.size.width, height: 524)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * UIView: Animation to show and hide errorMessageView
     */
    func showHideErrorMessageView() {
        UIView.animate(withDuration: 1, animations: {
            self.errorMessageView.transform = CGAffineTransform.init(translationX: 0, y: 108)
            self.disableView.alpha = 0.25
        }) {(true) in
            UIView.animate(withDuration: 2, delay: 2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.errorMessageView.transform = CGAffineTransform.init(translationX: 0, y: -108)
                self.disableView.alpha = 0
            })
        }
    }
    
    /*
     * UIButton: Action associated with submitBtn
     * Check user login credentials (email and login)
     */
    func showHideMenuView() {
        if arrowBtn.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = CGAffineTransform.init(translationX: 0, y: 380)
                self.arrowBtn.alpha = 0
                self.arrowBtnB.alpha = 1
                self.arrowBtnB.transform = CGAffineTransform.init(rotationAngle: self.radians(180))
                self.menuOptionView.alpha = 1
                self.usernameTextField.alpha = 0
                self.passwordTextField.alpha = 0
                self.rememberLabel.alpha = 0
                self.rememberSwitch.alpha = 0
                self.submitBtn.alpha = 0
                self.signUpScrollView.alpha = 0
                self.setProfileImageView.alpha = 0
                self.forgotPasswordView.alpha = 0
                self.forgotEmailView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.textField.resetTextField(textField: self.usernameTextField)
                    self.textField.resetTextField(textField: self.passwordTextField)
                    self.textField.resetTextField(textField: self.sufirstNameTextField)
                    self.textField.resetTextField(textField: self.sulastNameTextField)
                    self.textField.resetTextField(textField: self.suemailTextField)
                    self.textField.resetTextField(textField: self.suusernameTextField)
                    self.textField.resetTextField(textField: self.supasswordTextField)
                    self.textField.resetTextField(textField: self.suverifyPasswordTextField)
                    self.textField.resetTextField(textField: self.fpemailTextField)
                    self.textField.resetTextField(textField: self.fefirstNameTextField)
                    self.textField.resetTextField(textField: self.felastNameTextField)
                    self.textField.resetTextField(textField: self.feusernameTextField)
                })
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = .identity
                self.arrowBtnB.alpha = 0
                self.arrowBtn.alpha = 1
                self.menuOptionView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.usernameTextField.alpha = 1
                    self.passwordTextField.alpha = 1
                    self.rememberLabel.alpha = 1
                    self.rememberSwitch.alpha = 1
                    self.submitBtn.alpha = 1
                })
            }
        }
    }
    
    func showProfileImageView() {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.alpha = 0
            self.setProfileImageView.alpha = 1
            self.signUpScrollView.transform = CGAffineTransform.init(translationX: 0 - self.signUpScrollView.frame.width, y: 0)
            self.setProfileImageView.transform = CGAffineTransform.init(translationX: 0 - self.setProfileImageView.frame.width, y: 0)
        })
    }
    
    /*
     * UIButton: Action associated with submitBtn
     * Check user login credentials (email and login)
     */
    @IBAction func submitBtn(_ sender: Any) {
        if let email = usernameTextField.text, let pwd = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                (user, error) in
                if error == nil {
                    print("User Authenticated successfully")
                    self.usernameTextField.layer.borderWidth = 0
                    self.passwordTextField.layer.borderWidth = 0
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let profileVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                    self.show(profileVC, sender: self)
                    print("%@", user?.email  as Any)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                        (user, error) in
                        if error != nil {
                            print("Unable to authenticate using Email with Firebase")
                            if self.usernameTextField.text == "", self.passwordTextField.text == "" {
                                self.errorLabel.text = "Please fill out the required fields."
                                self.textField.setErrorTextField(textField: self.usernameTextField, borderWidth: 2)
                                self.textField.setErrorTextField(textField: self.passwordTextField, borderWidth: 2)
                                self.showHideErrorMessageView()
                            } else if self.usernameTextField.text == "" {
                                self.errorLabel.text = "Please enter username."
                                self.textField.setErrorTextField(textField: self.usernameTextField, borderWidth: 2)
                                self.passwordTextField.layer.borderWidth = 0
                                self.showHideErrorMessageView()
                            } else if self.passwordTextField.text == "" {
                                self.errorLabel.text = "Please enter password."
                                self.usernameTextField.layer.borderWidth = 0
                                self.textField.setErrorTextField(textField: self.passwordTextField, borderWidth: 2)
                                self.showHideErrorMessageView()
                            } else {
                                self.errorLabel.text = "Incorrect username and password. Please try again."
                                self.textField.setErrorTextField(textField: self.usernameTextField, borderWidth: 2)
                                self.textField.setErrorTextField(textField: self.passwordTextField, borderWidth: 2)
                                self.showHideErrorMessageView()
                            }
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func submitSignUp(_ sender: Any) {
        databaseReference = FIRDatabase.database().reference()
        FIRAuth.auth()?.createUser(withEmail: suemailTextField.text!, password: supasswordTextField.text!, completion: {user,error
            in
            if let error = error {
                self.signUpValidation()
                self.errorLabel.text = error.localizedDescription
                self.showHideErrorMessageView()
                print(error)
            } else if (self.supasswordTextField.text! != self.suverifyPasswordTextField.text!) {
                self.signUpValidation()
                self.textField.setErrorTextField(textField: self.supasswordTextField, borderWidth: 2)
                self.textField.setErrorTextField(textField: self.suverifyPasswordTextField, borderWidth: 2)
                self.errorLabel.text = "Passwords do not match"
                self.showHideErrorMessageView()
            } else {
                self.databaseReference.child("users").child(user!.uid).setValue([
                    "firstname":self.sufirstNameTextField.text,
                    "lastname:":self.sulastNameTextField.text,
                    "email":self.suemailTextField.text,
                    "username":self.suusernameTextField.text,
                    "password":self.supasswordTextField.text,
                    "profilepic":self.profileImageView.image?.description,
                ])
                self.supasswordTextField.layer.borderColor = UIColor.clear.cgColor
                self.suverifyPasswordTextField.layer.borderColor = UIColor.clear.cgColor
                self.errorLabel.text = "User Successfully Signed Up"
                self.showHideErrorMessageView()
                self.showProfileImageView()
//                self.showLoginView(#imageLiteral(resourceName: "submitBtn.png"))
            }
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }else{
            print("Error. Could not load image")
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion:nil)
    }
    
    @IBAction func submitProfileImage(_ sender: Any) {
        saveProfileToFirebaseStorage()
        
        
    }
    
    
    func saveProfileToFirebaseStorage(){
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference()
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
        {
            
            storedImage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        self.databaseReference.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["profilepic": urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                        })
                    }
                })// end storageImage.downloadURL
                
            })// end storageImage.put
        } // end if let uploadData
        errorLabel.text = "Profile Picture Set Successfully. Please Log In"
        showHideErrorMessageView()
        showLoginView(#imageLiteral(resourceName: "submitBtn.png"))
    }

    @IBAction func submitForgotPassword(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.fpemailTextField.text!, completion: {(error) in
            if error != nil {
                self.errorLabel.text = (error?.localizedDescription)!
                self.textField.setErrorTextField(textField: self.fpemailTextField, borderWidth: 2)
            } else {
                self.errorLabel.text = "Password reset has been sent"
                self.fpemailTextField.text = ""
                self.fpemailTextField.layer.borderColor = UIColor.clear.cgColor
                self.showLoginView(#imageLiteral(resourceName: "submitBtn.png"))
            }
            self.showHideErrorMessageView();
        })
    }
    
    @IBAction func submitForgotEmail(_ sender: Any) {
        
    }
    
    func signUpValidation() {
        if sufirstNameTextField.text == "" {
            textField.setErrorTextField(textField: sufirstNameTextField, borderWidth: 2)
        } else {
            sufirstNameTextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if sulastNameTextField.text == "" {
            textField.setErrorTextField(textField: sulastNameTextField, borderWidth: 2)
        } else {
            sulastNameTextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if suemailTextField.text == "" {
            textField.setErrorTextField(textField: suemailTextField, borderWidth: 2)
        } else {
            suemailTextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if suusernameTextField.text == "" {
            textField.setErrorTextField(textField: suusernameTextField, borderWidth: 2)
        } else {
            suusernameTextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if supasswordTextField.text == "" {
            textField.setErrorTextField(textField: supasswordTextField, borderWidth: 2)
        } else {
            supasswordTextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if suverifyPasswordTextField.text == "" {
            textField.setErrorTextField(textField: suverifyPasswordTextField, borderWidth: 2)
        } else {
            suverifyPasswordTextField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    /*
     * UIButton: Action associated with arrowBtn
     * Show menu options for sign up, sign in w/ facbook, forgot username, and forgort password
     */
    @IBAction func dropMenu(_ sender: Any) {
        showHideMenuView()
    }
    
    @IBAction func showLoginView(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.transform = .identity
            self.arrowBtnB.alpha = 0
            self.arrowBtn.alpha = 1
            self.menuOptionView.alpha = 0
            self.signUpScrollView.alpha = 0
            self.setProfileImageView.alpha = 0
            self.forgotPasswordView.alpha = 0
            self.forgotEmailView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.usernameTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.rememberLabel.alpha = 1
                self.rememberSwitch.alpha = 1
                self.submitBtn.alpha = 1
            })
        }
    }
    
    @IBAction func showSignUpView(_ sender: Any) {
        if signUpScrollView.transform == .identity && setProfileImageView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = .identity
                self.arrowBtnB.alpha = 0
                self.arrowBtn.alpha = 1
                self.menuOptionView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.signUpScrollView.alpha = 1
               })
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.arrowBtn.transform = .identity
                self.arrowBtnB.alpha = 0
                self.arrowBtn.alpha = 1
                self.menuOptionView.alpha = 0
                self.signUpScrollView.transform = .identity
                self.setProfileImageView.transform = .identity
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    self.signUpScrollView.alpha = 1
                })
            }
        }
    }
    
    @IBAction func showForgotPasswordView(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.transform = .identity
            self.arrowBtnB.alpha = 0
            self.arrowBtn.alpha = 1
            self.menuOptionView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.forgotPasswordView.alpha = 1
            })
        }
    }
    
    @IBAction func showForgotEmailView(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.arrowBtn.transform = .identity
            self.arrowBtnB.alpha = 0
            self.arrowBtn.alpha = 1
            self.menuOptionView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.forgotEmailView.alpha = 1
            })
        }
    }
    
    @IBAction func loginWithFacebbok(_ sender: UIButton) {
        facebookSignIn()
    }
    
    func facebookSignIn(){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            if error != nil {
                print("Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                    print("User cancelled authentication with Facebook")
            } else {
                print("Successfully authenticaed with Facebook - \(error)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print("Unable to authenticate with firebase - \(error)")
            } else {
                print("Successfully authenticated with firebase")
            }
        })
    }
    
    /*
     * CGFloat: Degrees to Radians
     */
    func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}


