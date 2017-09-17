//
//  LoginViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import NVActivityIndicatorView
import Firebase

class LoginViewController: ViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //connects the username textfield
    @IBOutlet weak var usernameTextField: UITextField!
    //connects the password text field
    @IBOutlet weak var passwordTextField: UITextField!
    //keeps track of last selected text field
    var activeField:UITextField?
    //scroll view connector
    @IBOutlet weak var scrollView: UIScrollView!
    //action when login button is pressed
    @IBAction func loginButton(_ sender: Any) {

        let model = LoginModel()
        model.email = usernameTextField.text!
        model.password = passwordTextField.text!
        
        FirebaseHelper.login(model)
        
//        //error correction
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        if emailTest.evaluate(with: usernameTextField.text!) && !passwordTextField.text!.isEmpty {
//            
//            //animate screen when waiting for server response
//            startAnimating(CGSize(width: 40, height: 40), message: "Logging In", type: NVActivityIndicatorType(rawValue: 8)!)
//            
//            //login function
//            TacPacServer.login(username: usernameTextField.text!, password: passwordTextField.text!, completionHandler: {
//                (error) in
//                //chagne ui in main thread
//                DispatchQueue.main.async {
//                    //stop loading animation
//                    self.stopAnimating()
//                    //adds to mainthread queue
//                    if error != nil {
//                        //creates dialog
//                        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    } else {
//                        //instantiate controller
//                        let story = UIStoryboard(name: "Main", bundle: nil)
//                        let vs = story.instantiateInitialViewController()
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.window?.rootViewController = vs
//                    }
//                }
//            })
//        
//            
//        } else {
//            //error detection
//            print("Invalid input")
//        }
    }
    
    //called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add keyboard for scrollview movement
        registerForKeyboardNotifications()
        //assign delegates for text fields
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
//        let model = LoginModel()
//        model.email = "test@gmail.com"
//        model.password = "test123"
//        
//        FirebaseHelper.login(model)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hides nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //shows nav bar for other views
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        //scrolls frame according to keyboard size
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //set last selected text field
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        //set no textfield as selected
        activeField = nil
    }
}
