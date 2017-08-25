//
//  LoginViewController.swift
//  MigraineKiller
//
//  Created by Xue Han on 2017-07-07.
//  Copyright © 2017 Shelly. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var firebaseReference: DatabaseReference!
    
    @IBOutlet weak var toggle: UISegmentedControl!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
        nameField.text = ""
        nameField.text = ""
        pwdField.text = ""
        
        if sender.selectedSegmentIndex == 0 {
            
            nameField.isHidden = true
            submitButton.setTitle("LOGIN", for: .normal)
            
        }
        else {
            
            nameField.isHidden = false
            submitButton.setTitle("REGISTER", for: .normal)
        }
    }

    @IBAction func submit(_ sender: Any) {
        
        if toggle.selectedSegmentIndex == 1 {
            
            handleRegister()
            print("The toggle is submit!!!!")
        }
        else {
            
            handleLogin()
            print("The toggle is set to Login")
        }
    }

    
    //-------------
    
        func handleLogin() {
            
            if (self.emailField.text == "" || self.pwdField.text == "") {
                
                let emptyEmailandPassAlert = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
                let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                emptyEmailandPassAlert.addAction(defaulAction)
                
                self.present(emptyEmailandPassAlert, animated: true, completion: nil)
            }
                
                //checking the authentication:
            else {
                Auth.auth().signIn(withEmail: self.emailField.text!, password: self.pwdField.text!, completion: { (user, error) in
                    if error != nil {
                        
                        let loginPageError = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        loginPageError.addAction(defaulAction)
                        self.present(loginPageError, animated: true, completion: nil)
                        return
                    }
                    else{
                        
                        print("login successful")
                        //self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "accountSettleID", sender: self)
                    }
                })
            }
        }
        
        func handleRegister() {
            
            //let name = nameField.text
            
            if (self.emailField.text == "" || self.pwdField.text == "") {
                
                let emptyEmailandPassAlert = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
                let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                emptyEmailandPassAlert.addAction(defaulAction)
                
                self.present(emptyEmailandPassAlert, animated: true, completion: nil)
            }
                
            else if self.nameField.text == "" {
                
                let emptyUsernameAlert = UIAlertController(title: "Oops!", message: "Please enter your name in the name field.", preferredStyle: .alert)
                let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                emptyUsernameAlert.addAction(defaulAction)
                self.present(emptyUsernameAlert, animated: true, completion: nil)
            }
                
            else {
                
                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.pwdField.text!, completion: { (user: User?, error) in
                    if error != nil {
                        
                        let registerErrorAlert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        registerErrorAlert.addAction(defaulAction)
                        self.present(registerErrorAlert, animated: true, completion: nil)
                        return
                    }
                    /*
                    guard let userUID = user?.uid
                        else {
                            
                            return
                    }
                    self.firebaseReference = Database.database().reference()
                    let userReferenceInDatabase = self.firebaseReference.child("Users").child(userUID)
                    
                    //get url for the default profile pic
                    
                    let storageRef = Storage.storage().reference()
                    let defaultImage = storageRef.child("Unknown.jpeg")
                    
                    defaultImage.downloadURL(completion: { (url, error) in
                        if error != nil {
                            
                            print(error!)
                            return
                        }
                        if let defaultURLText = url?.absoluteString {
                            
                            //insert user and data associated
                            let values = ["user": name, "email": self.emailField.text!, "pic": defaultURLText]
                            userReferenceInDatabase.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                
                                if err != nil {
                                    print(err!)
                                    return
                                }
                            })
                        }
                    })
 */
                    
                    print("Create account successful")
                    self.performSegue(withIdentifier: "accountSettleID", sender: self)
                })
            }
        }
        
    
        //MARK: UIViewController
        
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            emailField.delegate = self
            nameField.delegate = self
            pwdField.delegate = self

            firebaseReference = Database.database().reference()
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            
            view.addGestureRecognizer(tap)
        }
    
    
        func dismissKeyboard() {
            view.endEditing(true)
        }
    
    

    
        
        //MARK: UITextFieldDelegate
        
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            textField.returnKeyType = UIReturnKeyType.done
            self.emailField.keyboardType = UIKeyboardType.emailAddress
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
