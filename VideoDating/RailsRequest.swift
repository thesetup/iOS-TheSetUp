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

let API_URL = "New URL Goes Here"

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
    
    var email: String!
    var firstname: String!
    var lastname: String!
    var password: String!
    
    func logOut() {
        
        email = ""
        firstname = ""
        lastname = ""
        password = ""
        
        token = nil
        
    }
    
    func registerWithCompletion(completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/users/register",
            "parameters" : [
                
                "password" : password,
                "first_name" : firstname,
                "last_name" : lastname,
                "email" : email,
                
            ],
            
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
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
                
                completion()
                
            }
            
        })
        
    }
    
    
    func postImage(imageURL: String, answer: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/posts/new",
            "parameters" : [
                
                "image_url":imageURL,
                "answer":answer
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
        })
        
    }
    
    func guessImage(postId: String, guess: String, completion: () -> Void) {
        
        var isCorrect: Bool?
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/guesses",
            "query" : [
                
                "post_id":postId,
                "guess":guess
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            isCorrect = responseInfo?["won"] as? Bool
            
            completion()
            
        })
        
    }
    
    func getPlayablePosts(completion: (posts: [AnyObject]) -> Void) {
        
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/posts/all/playable",
            
            "query" : [
                
                "page" : 1
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            
            println(responseInfo)
            
            if let posts = responseInfo as? [AnyObject] {
                
                completion(posts: posts)
                
            } else {
                
                completion(posts: [])
                
            }
            
            
        })
        
    }
    
    
    
    func scoreboard(username: String, score: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/topscores",
            "parameters" : [
                
                "user_name":username,
                "score":score
                
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
