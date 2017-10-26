//
//  MeasurementScreenController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class MeasurementViewController: ViewController, NVActivityIndicatorViewable {
    //connects measurement textfield to variable
    @IBOutlet weak var measurementTextField: UITextField!
    //connects view to variable
    @IBOutlet var mainView: UIView!
    //save button pressed
    @IBAction func saveButtonPress(_ sender: Any) {
        //ensures text is not empty
        if let text = measurementTextField.text, text != "" {
            
            //hides keyboard
            self.measurementTextField.resignFirstResponder()
            //formats date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let result = String(NSDate().timeIntervalSince1970*1000)
            
            //TODO make sure only number are typed
            let measurement = TacMeasurement(concentration: Double(text)!, time:result)
            //loading animation start
//            startAnimating(CGSize(width: 40, height: 40), message: "Uploading", type: NVActivityIndicatorType(rawValue: 8)!)
            
            let reading = Reading()
            reading.concentration = Double(text)!
            reading.time = result
            FirebaseHelper.saveReading(reading)
            self.measurementTextField.text = ""
            self.navigationController?.popViewController(animated: true)

            //function to upload measurement to server
//            TacPacServer.uploadMeasurement(measurement, completion: {
//                (httCode) in
//                
//                DispatchQueue.main.async {
//                    //remove loacding overlay
//                    self.stopAnimating()
//                    if httCode == 200 {
//                        //remove text
//                        self.measurementTextField.text = ""
//                        self.navigationController?.popViewController(animated: true)
//                        //check mark animation TODO---------
//                    } else {
//                        let alert = UIAlertController(title: "Error", message: "Error Uploading Measurement!", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//                
//            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hide keyboard
        measurementTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
