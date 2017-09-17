//
//  TacPacServer.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class TacPacServer: NSObject {
    
    //stores token for login
    static var token: String?
    //server API URI
    static var urlBase: String = "http://custom-env.fz4bnsa2mh.us-west-2.elasticbeanstalk.com/";
    
    //logon function POST
    static func login(username: String, password: String, completionHandler: @escaping (String?)->Void) {
        var request = URLRequest(url: URL(string: urlBase + "/token")!)
        request.httpMethod = "POST"
        //passes password and username for a token in return
        let postString = "grant_type=password&username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print(error)
                completionHandler(error as! String?)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                //if reponse is good (200), record token
                if httpStatus.statusCode != 200 {
                    var Emsg:String?
                    
                    if httpStatus.statusCode == 400 {
                        Emsg = "Invalid username or password!"
                    }
                    
                    completionHandler(Emsg)
                } else if httpStatus.statusCode == 200{
                    //show user the error
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                        
                        let token = json["access_token"] as! String
                        
                        self.token = token
                        
                        //save token
                        KeychainWrapper.standard.set(self.token!, forKey: "token")
                        
                        completionHandler(nil)
                        
                    } catch{
                        print("Error with Json")
                    }
                }
            }
            
            
            
        }
        //run task above
        task.resume()
    }
    //register new users  POST
    static func signup(username: String, password: String, firstName: String, lastName: String, birthday: String, completion: @escaping (_ httpCode: Int, _ msg:String) -> Void) {
        
        var request = URLRequest(url: URL(string: urlBase + "/api/Account/Register")!)
        request.httpMethod = "POST"
        //passes email, password, first name, last name, dob
        let postString = "Email=\(username)&Password=\(password)&FirstName=\(firstName)&LastName=\(lastName)&Birthday=\(birthday)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //ensure no error occured - server side
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            //displays error
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                var Emsg = String(data:data, encoding: .utf8)
                
                completion(httpStatus.statusCode, Emsg!)
                
                if httpStatus.statusCode == 400 {
                    Emsg = "Invalid username or password!"
                }
                print(Emsg)
            } else {
                //if everything works
                print("Registration Successful")
                
            }
            
        }
        //runs taks above
        task.resume()
        
    }
    //stores new measurement - POST
    static func uploadMeasurement(_ measurement: TacMeasurement, completion: @escaping(_ code:Int)->Void) {
        POSTrequest(place: "api/Tacpac/addMeasurement", body: measurement.toJSON()!, completion: {
            httpCode, data in
            
            ///TODO ERROR DETECTION
            completion(httpCode)
        })
    }
    
    //gets measurement from server POST
    static func getMeasurements(amount: Int, completion: @escaping (_ measurements: [TacMeasurement]?, _ error: String?) -> Void ) {
        POSTrequest(place: "api/Tacpac/getPastMeasurement", body: "\(amount)", completion: {
            httpCode, data in
            
            //            print(String(data:data, encoding: .utf8))
            
            //call callback function if everything is OK
            if httpCode == 200 {
                do{
                    var mArray = [TacMeasurement]()
                    
                    let json = try JSONSerialization.jsonObject(with: data) as! [AnyObject]
                    
                    for item in json {
                        let concentration = item["concentration"] as! Double
                        let time = item["time"] as! String
                        
                        let measure = TacMeasurement(concentration: concentration, time: time)
                        measure.id = item["id"] as! Int
                        mArray.append(measure)
                    }
                    
                    completion(mArray, nil)
                    
                } catch{
                    //reports error
                    completion(nil, "Error with Json")
                }
            } else {
                //returns nil if error occured
                completion(nil, String(data:data, encoding: .utf8))
            }
            
        })
    }
    //sends patients data to specified email POST
    static func export(email:String, completion: @escaping (_ error: String?) -> Void) {
        POSTrequest(place: "api/Tacpac/sendEmail", body: "\"\(email)\"", completion: {
            httpCode, data in
            
            //if OK, then no error occured
            if httpCode == 200 {
                completion(nil)
            } else {
                //tell user an error occured -- server side
                print(httpCode)
                completion("Error Occured")
            }
            
        })
    }
    
    //function that ensures that the token is still valid
    static func checkToken(completion: @escaping (_ error: Bool) -> Void) -> Void{
        
        POSTrequest(place: "api/Account/checkToken", body: "", completion: {
            (httpCode, data) in
            //if no error, then the token is function
            if httpCode == 200 {
                let msg = String(data:data, encoding: .utf8)
                if (msg?.contains("denied"))! {
                    completion(false)
                    return
                } else {
                    completion(true)
                }
            } else {
                //error occured
                completion(false)
            }
            
        })
        
    }
    
    //function that simplifies a POST call
    static func POSTrequest(place:String, body: String, completion: @escaping (_ httpCode: Int, _ data:Data) -> Void) {
        //inputs URI base
        var request = URLRequest(url: URL(string: urlBase + place)!)
        request.httpMethod = "POST"
        //Inouts the token needed
        request.addValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body.data(using: .utf8)
        //handles errors
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print(error)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                do {
                    //print(data)
                    completion(httpStatus.statusCode, data)
                } catch {
                    print("Error with Json")
                    completion(httpStatus.statusCode, data)
                }
            }
            
        }
        task.resume()
    }
    
}

