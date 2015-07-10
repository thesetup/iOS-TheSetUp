//
//  RailsRequest.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = RailsRequest()

let API_URL = "https://still-island-6789.herokuapp.com"

class RailsRequest: NSObject {
    
    class func session() -> RailsRequest { return _singleton }
    
    var token: String? {
        
        get {
            
            return defaults.objectForKey("TOKEN") as? String
            
        }
        
        set {
            
            defaults.setValue(newValue, forKey: "TOKEN")
            defaults.synchronize()
            
        }
        
    }
    
    var userId: Int? {
        
        get {
            
            return defaults.objectForKey("Id") as? Int
            
        }
        
        set {
            
            defaults.setValue(newValue, forKey: "Id")
            defaults.synchronize()
            
        }
        
    }
    
    var email: String!
    var username: String!
    var password: String!
    var registerID: Int!
    var loginID: String!
    var createdAt: String!
    var updatedAt: String!
    
    func logOut() {
        
        email = ""
        username = ""
        password = ""
        
        token = nil
        
    }
    
    func registerWithCompletion(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/users/register",
            "parameters" : [
                
                "username": username,
                "email" : email,
                "password" : password,
                
            ],
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                if let id = responseInfo?["id"] as? Int {
                    
                    self.userId = id
                    
                }
                
                completion()
                
            }
            
        })
        
    }
    
    func login(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/users/login",
            "parameters" : [
                
                "email" : email,
                "password" : password,
                
            ],
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                if let id = responseInfo?["id"] as? Int {
                    
                    self.userId = id
                    
                }
                
                completion()
                
            }
            
        })
        
    }
    
    func createProfile(friendEmail: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/profiles",
            "parameters" : [
                
                "email": friendEmail,
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
        })
        
    }
    
    func updateProfile(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/posts/new",
            "parameters" : [
                
               
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
        })
        
    }
    
    func getAllProfiles(completion: (profilesInfo: [[String:AnyObject]]) -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/profiles"
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            completion(profilesInfo: responseInfo as! [[String:AnyObject]])
            println("Get all profiles response info! \(responseInfo)")
            
            
        })
        
    }
    
    func getProfile(userId: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/profiles/\(userId)",
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println("Get single profile response info! \(responseInfo)")
            
            
        })
        
        
        
    }
    
    
    func postImage(imageURL: String, answer: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/posts/new",
            "parameters" : [
                
                "image_url": imageURL,
                "answer": answer
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            
        })
        
    }
    

    
    
    func requestWithInfo(info: [String:AnyObject], andCompletion completion: ((responseInfo: AnyObject?) -> Void)?) {
        
        var endpoint = info["endpoint"] as! String
        
        // query parameters for GET request
        if let query = info["query"] as? [String:AnyObject] {
            
            var first = true
            
            for (key,value) in query {
                
                // choose sign if it is first ? else :
                var sign = first ? "?" : "&"
                
                endpoint = endpoint + "\(sign)\(key)=\(value)"
                
                // set first the first time it runs
                first = false
                
            }
            
        }
        
        if let url = NSURL(string: API_URL + endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = info["method"] as! String
            
            ///////HEADER
            
            if let token = token {
                
                request.setValue(token, forHTTPHeaderField: "Access-Token")
                
            }
            
            /////// BODY
            
            if let bodyInfo = info["parameters"] as? [String:AnyObject] {
                
                let requestData = NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions.allZeros, error: nil)
                
                let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
                
                let postLength = "\(jsonString!.length)"
                
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                
                let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.HTTPBody = postData
                
            }
            
            ////// BODY
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                    
                    completion?(responseInfo: json)
                    
                }
                
            })
            
        }
        
    }
    
}
