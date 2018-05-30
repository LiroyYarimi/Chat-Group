//
//  LogInViewController.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import LocalAuthentication//use TouchID

class LogInViewController: UIViewController {

    var userEmail = ""
    var userPassword = ""
    let defaults = UserDefaults.standard //varibale that can save data even user terminate our app
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let email = defaults.string(forKey: "UserEmail"){ //get from our saving box
            userEmail = email
        }
        if let password = defaults.string(forKey: "UserPassword"){ //get from our saving box
            userPassword = password
        }
        if userEmail != "" && userPassword != ""{ //let's use touch ID to log in
            EnterWithtouchID()
        }
        print("userEmail: \(userEmail) , userPassword: \(userPassword)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func logInPressed(_ sender: AnyObject) {
        
        saveUserEmailAndPassword()

    }
    
    func EnterWithtouchID(){
        
        print("EnterWithtouchID")
        let auth = LAContext()
        
        //check if touch ID is possible on the device
        if auth.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil){
            
            auth.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Put your finger on the home button") { (success, error) in
                SVProgressHUD.show()
                if error != nil{
                    print("Invalid")
                }
                else{
                    print("success")
                    self.logIn(email: self.userEmail, password: self.userPassword)
                }
            }
        }
        else{
            print("Your device not support touch ID")
            
            //let's make a pop up message to user that say we have a problem
            let alert = UIAlertController(title: "Error", message: "Your device not support touch ID", preferredStyle: .alert) // the message
            let tryAgain = UIAlertAction(title: "OK", style: .default)
            alert.addAction(tryAgain)
            self.present(alert, animated: true, completion: nil) // present the message
        }
    }
    
    func saveUserEmailAndPassword(){
        
        let alert = UIAlertController(title: "Welcome", message: "Would you like to use Touch ID for next enters?", preferredStyle: .alert) // the message
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (UIAelrtAction) in
            
            if let email = self.emailTextfield.text{
                if let password = self.passwordTextfield.text{
                    self.userEmail = email
                    self.userPassword = password
                    
                    print("userEmail: \(email) , userPassword: \(password)")
                    self.defaults.set(email, forKey: "UserEmail") //add itemArray to our saving box
                    self.defaults.set(password, forKey: "UserPassword")
                    
                    self.chackTextFields()
                }
            }
        }
        let no = UIAlertAction(title: "No Thank", style: .default) { (UIAelrtAction) in
            self.chackTextFields()
        }

        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil) // present the message
    }
    
    func chackTextFields(){
        if let email = emailTextfield.text{
            if let password = passwordTextfield.text{
                logIn(email: email, password: password)
            }
        }
    }
    
    func logIn(email : String, password : String){
        
        SVProgressHUD.show()
        
        //Log in the user
        
        
        Auth.auth().signIn(withEmail: email, password: password) { // log in user
            (user, error) in
            if error == nil{
                
                print("log in successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            else{
                print("Error: log in crash")
                print(error!)
                SVProgressHUD.dismiss()
                
                //let's make a pop up message to user that say we have a problem
                let alert = UIAlertController(title: "Error", message: "One of the detail is wrong. Please try again", preferredStyle: .alert) // the message
                let tryAgain = UIAlertAction(title: "OK", style: .default)
                alert.addAction(tryAgain)
                self.present(alert, animated: true, completion: nil) // present the message
            }
        }
    }

}
