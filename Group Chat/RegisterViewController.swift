//
//  RegisterViewController.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //Set up a new user on our Firbase database
        
        if let email = emailTextfield.text {
            if let password = passwordTextfield.text{
                Auth.auth().createUser(withEmail: email, password: password) {// create new user in are app
                    (user, error) in //this closure - what to do after we finished
                    
                    if error != nil{
                        print(error!)
                        SVProgressHUD.dismiss()
                        //let's make a pop up message to user that say we have a problem
                        let alert = UIAlertController(title: "Error", message: "One of the detail is wrong. Please try again", preferredStyle: .alert) // the message
                        let tryAgain = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(tryAgain)
                        self.present(alert, animated: true, completion: nil) // present the message
                    }
                    else{
                        print("Registeration successful")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                    }
                }
            }
        }
    }

}
