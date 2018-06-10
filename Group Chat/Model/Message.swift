//
//  Message.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

//Message model

class Message {
    
    
    private var sender : String?
    private var messageBody : String?
    
    init() {
        sender = ""
        messageBody = ""
    }
    
    init(otherSender : String, otherMessageBody : String) {
        sender = otherSender
        messageBody = otherMessageBody
    }
    
    func getSender() -> String?{
        return sender
    }
    func setSender(otherSender : String){
        sender = otherSender
    }
    func getMessageBody() -> String?{
        return messageBody
    }
    func setMessageBody(otherMessageBody : String){
        messageBody = otherMessageBody
    }
    
    func toString()-> String?{
        if sender != nil && messageBody != nil{
            return "sender: \(sender!) \t messageBody: \(messageBody!)"
        }
        return nil
    }
    
    
}
