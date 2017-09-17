//
//  SignupViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: ViewController, UITextFieldDelegate {
    
    //connects email textfield to variable
    @IBOutlet weak var emailTextField: UITextField!
    //connects password textfield to variable
    @IBOutlet weak var passwordTextField: UITextField!
    //connects first name textfield to variable
    @IBOutlet weak var firstnameTextField: UITextField!
    //connects last name textfield to variable
    @IBOutlet weak var lastnameTextField: UITextField!
    //connects birthday textfield to variable
    @IBOutlet weak var birthdayTextField: UITextField!
    //connects scroll view textfield to variable
    @IBOutlet weak var scrollView: UIScrollView!
    //connects active textfield to variable
    @IBOutlet weak var codeTextField: UITextField!
    var activeField: UITextField?
    
    //custom select picler for dates
    @IBAction func birthdayStartEditing(_ sender: UITextField) {
        //creates date picker
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        //shows date picker
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
    }
    
    //sign up button pressed
    @IBAction func signupButton(_ sender: Any) {
        
        let model = SignupModel()
        model.email = emailTextField.text!
        model.password = passwordTextField.text!
        model.firstName = firstnameTextField.text!
        model.lastName = lastnameTextField.text!
        model.dob = birthdayTextField.text!
        model.code = codeTextField.text!
        
        FirebaseHelper.signup(model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when textfield is not tapped
        self.hideKeyboardWhenTappedAround()
        //registers tap action
        registerForKeyboardNotifications()
        
        //set delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        birthdayTextField.delegate = self
        codeTextField.delegate = self
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        //creates date formatted for registering user
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTextField.text = dateFormatter.string(from: sender.date)
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
        //keeps track of selected text field
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        //removes selected text field
        activeField = nil
    }
    
}

extension UIViewController {
    // hide keybaord function
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //same as above
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
