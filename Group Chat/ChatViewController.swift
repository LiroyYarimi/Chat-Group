//
//  ChatViewController.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint! //link to heightConstraint of Compose View
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        messageTextfield.delegate = self // it's mean that we will get called when user pressed on textFild
        
        

        //this two line are add a new Gesture to the tableView. it's mean that when we press on the tableView it call the method tableViewTapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))// make a new gesture
        messageTableView.addGestureRecognizer(tapGesture)// add this new gesture to our tableView
        
        
        // install the zip file
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView() // change the cell size
        retrieveMessages() //we need to call this method one time and after it, the database call it automatically when there new message.

        messageTableView.separatorStyle = .none//hide all the separate line between the message on the tableView
        
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //this method get called when the tableView search what to show for user.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        //create new object of type CustomMessageCell and show it on the tableView
        //this new object is actually design object and not the standard of the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //indexPath.row == the row in the tableView
        //change the cell property
        cell.messageBody.text = messageArray [indexPath.row].messageBody
        cell.senderUsername.text = messageArray [indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{ // if we send this message, then change the color of background
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        return cell //this return mean that "present this cell in the table view"
 
 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        let arr = ["first message", "second message", "third message"]
        cell.messageBody.text = arr[indexPath.row]
        return cell
        
    }
    
    
    //it's rule the number of row in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//messageArray.count
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int { // number of section
    //        return 2
    //    }
    
    
    //this method called when user press on the tableView
    //the method start with "@objc" becuse it's called from "#selector"
    @objc func tableViewTapped () {
        messageTextfield.endEditing(true) //this line call the method "textFieldDidEndEditing"
    }
    
    
    //it's make the cell message size to fit to the text
    //the standard of height for each cell is 44. but we can't limited the cell to 44 because if someone send a large message it will cut so change the height for each cell to the correct size (according the text inside)
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    
    //this func call automatically when user press on textFild (it's work because the delegate)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        heightConstraint.constant = 308
        //        view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 0.5){//make it with animate
            self.heightConstraint.constant = 308  //the keyboard is height 258 and the text fild (on this case) 50 height
            //hebrew keyboard is 216
            self.view.layoutIfNeeded() // update the screen
        }
    }
    
    
    
    
    //we need to call this method manually
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
 
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //messageTextfield.endEditing(true) // call the method textFieldDidEndEditing
        //Send the message to Firebase and save it in our database
        
        //this two line freeze the the textFild and sendButton for to send one time (and not two by accident)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages") //create new object of type child from the Database.
        //all the messages save under the title "Messages" on the database (server)
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!] //the message
        
        messagesDB.childByAutoId().setValue(messageDictionary){ //add the message to the database (on the server)
            //childByAutoId == create new identify key for each message
            (error, reference) in //what to do after saving the message
            
            if error != nil{
                print(error!)
            }
            else{
                print("Message save successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
            
        }
        
    }
    

    func retrieveMessages(){
        let messagesDB = Database.database().reference().child("Messages")//the name of the database is "Messages". So if we want to get data from server is very importent to spell it right "Messages"
        
        messagesDB.observe(.childAdded){ (snapshot) in// this closure call every time that there is a new message in the database
            let snapshotValue = snapshot.value as! Dictionary<String,String> //get the new message
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            //print("message: \(message.toString())")
            self.messageArray.append(message) //add the new message to our array
            
            self.configureTableView() // fix the cell size
            self.messageTableView.reloadData()//this line update the tableView screen by call cellForRowAt method
        }
    }
    
    
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //Log out the user and send them back to WelcomeViewController
        
        //Auth.auth().signOut()
        //this line make error because it suppose to throws message so we need to catch it. like this,
        
        do{
            try Auth.auth().signOut() // log out the user from chat
            
            navigationController?.popToRootViewController(animated: true) //go to root (base) screen
        }
        catch{
            print("Error: there was a problem logging out")
            
            //let's make a pop up message to user that say we have a problem
            let alert = UIAlertController(title: "Error", message: "There was a problem logging out", preferredStyle: .alert) // the message
            let tryAgain = UIAlertAction(title: "OK", style: .default)
            alert.addAction(tryAgain)
            self.present(alert, animated: true, completion: nil) // present the message
        }
    }
    
    
    
}
