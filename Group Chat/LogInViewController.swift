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

class LogInViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //Log in the user
        
        if let email = emailTextfield.text{
            if let password = passwordTextfield.text{
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
        
    }

}
