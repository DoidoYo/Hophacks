//
//  TempViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class TempViewController: ViewController {
    
    
    @IBAction func logout(_ sender: Any) {
        //removes token from memory
        KeychainWrapper.standard.remove(key: "token")

        //instantiate controller
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vs = story.instantiateViewController(withIdentifier: "LoginScreen")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vs
    }
    
}
