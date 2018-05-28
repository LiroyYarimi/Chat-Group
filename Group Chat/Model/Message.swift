//
//  Message.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

//Message model

class Message {
    
    
    var sender : String = ""
    var messageBody : String = ""
    
    func toString()-> String{
        return "sender: \(sender) \t messageBody: \(messageBody)"
    }
    
    
}
