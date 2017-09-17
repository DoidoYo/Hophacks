//
//  ExportViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ExportViewController: UIViewController, NVActivityIndicatorViewable {
    
    //connects navigation item to variable
    @IBOutlet weak var navItem: UINavigationItem!
    //connects email textfield to variable
    @IBOutlet weak var emailTextField: UITextField!
    
    //called when send button is pressed
    @IBAction func sendPressed(_ sender: Any) {
        //starts loading animation
        startAnimating(CGSize(width: 40, height: 40), message: "Sending Data", type: NVActivityIndicatorType(rawValue: 8)!)
        //hide keyboard
        emailTextField.resignFirstResponder()
        //function to export data from server
        TacPacServer.export(email: emailTextField.text!, completion: {
            err in
            DispatchQueue.main.async {
                //stops animation, and clears textfield
                self.stopAnimating()
                self.emailTextField.text = ""
                if let e = err {
                    self.emailTextField.becomeFirstResponder()
                    let alert = UIAlertController(title: "Error", message: e, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
                //go back to previous screen
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //show keyboard when this screen appears
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //hide keyboard when screen hides
        emailTextField.resignFirstResponder()
    }
}
