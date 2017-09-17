//
//  FirebaseHelper.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 9/16/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseHelper {
    
    public static var user:Firebase.User?
    
    public static var first_name:String?
    public static var last_name:String?
    public static var dob:String?
    
    static let dbRef = Database.database().reference()
    
    public static func login(_ model:LoginModel) {
        
        Auth.auth().signIn(withEmail: model.email, password: model.password, completion: {
            (user, error) in
            
            if let error = error {
                print("ERROR: \(error)")
            } else {
                self.user = user
                openStartScreen()
            }
            
            
        })
        
    }
    
    private static func openStartScreen() {
        //instantiate controller
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vs = story.instantiateViewController(withIdentifier: "StartVC")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vs
    }
    
    public static func signup(_ model:SignupModel) {
        
        
        dbRef.child("Users").queryOrdered(byChild: "code").queryEqual(toValue: model.code).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let snap = snapshot.value as? NSDictionary {
                print("FOUND")
                let doctorId = snap.allKeys[0] as! String
                
                Auth.auth().createUser(withEmail: model.email, password: model.password, completion: {
                    (user, error) in
                    
                    if let error = error {
                        print("ERROR: \(error)")
                    } else {
                        self.user = user
                        //register other aspects
                        dbRef.child("Users").child(user!.uid).setValue(["first_name":model.firstName, "last_name":model.lastName, "dob":model.dob])
                        dbRef.child("Physicians").child(doctorId).child(user!.uid).setValue(["id":user!.uid])
                        
                        openStartScreen()
                    }
                })
                
            } else {
                print("code does not exist!")
            }
        })
        
        
    }
    
    public static func saveReading(_ read: Reading) {
//        let reading = dbRef.child("Readings").childByAutoId()
//        reading.setValue(["measurement":read.concentration, "time":read.time])
//        let readingId = reading.key
        dbRef.child("Patients").child(user!.uid).childByAutoId().setValue(["measurement":read.concentration, "time":read.time])
    }
    
    
    
    public static func getMeasurements(completion: @escaping (_ readings:[Reading]) -> Void) {
        dbRef.child("Patients").child(user!.uid).queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            (snapshot) in

            var readings:[Reading] = []
            if let val = snapshot.value as? NSDictionary {
             
                for key in val.allKeys {
                    if let val2 = val[key] as? NSDictionary {
                        let reading = Reading()
                        reading.concentration = val2["measurement"] as! Double
                        reading.time = val2["time"] as! String
                        readings.append(reading)
                    }
                }
                
            }
            completion(readings)
            
//            print(snapshot)
//            var readings:[Reading] = []
//            if let val = snapshot.value as? NSDictionary {
//                for key in val.allKeys {
//                    
//                    let reading = Reading()
//                    
//                    dbRef.child("Readings").child(key as! String).observeSingleEvent(of: .value, with: {
//                        (snapshot2) in
//                    
//                        if let val2 = snapshot2.value as? NSDictionary {
//                            reading.concentration = val2["measurement"] as! Double
//                            reading.time = val2["time"] as! String
//                            readings.append(reading)
//                        }
//                        
//                    })
//                    
//                    
//                }
//            }
//            completion(readings)
        })
        
    }
    
}
