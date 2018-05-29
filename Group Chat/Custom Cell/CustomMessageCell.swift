//
//  CustomMessageCell.swift
//  Chat Group
//
//  Created by liroy yarimi on 28.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

/*
 How to create this class and the MessageCell.xib file:
 command + N to create new file. then choose Cocoa Touch Class.
 then choose UIViewController and be in the project folder and choose Also ceate XIB file (chack box).
 
 */

import UIKit

class CustomMessageCell: UITableViewCell {
    
    
    
    @IBOutlet var messageBackground: UIView!
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var messageBody: UILabel!
    
    @IBOutlet var senderUsername: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }
    
    
}
