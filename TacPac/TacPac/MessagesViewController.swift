//
//  MessagesViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 10/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import NMessenger
import IQKeyboardManagerSwift
import Firebase

class MessagesViewController: NMessengerViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        let dbRef = Database.database().reference()
        dbRef.child("Chat").child(FirebaseHelper.chatId!).observe(.childAdded, with: {
            (snapshot) in
            
            let data = snapshot.value as! NSDictionary
            print(data)
            if let snd = data["sender"] as? Int{
                
                if snd  == 0 {
                self.addText(data["text"] as! String, incoming: false)
                } else {
                    self.addText(data["text"] as! String, incoming: true)
                }
            }
            
        })
    }
    
    func addText(_ text:String, incoming: Bool) {
        let newMessage = createTextMessage(text, isIncomingMessage: incoming)
        self.addMessageToMessenger(newMessage)
    }
    
    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        
        if !isIncomingMessage {
            FirebaseHelper.sendMessage(text)
        }
        
        //just cause
        return GeneralMessengerCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    
}
