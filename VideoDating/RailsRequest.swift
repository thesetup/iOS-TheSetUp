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
    
    // This singleton contains everything related to my Ruby on Rails API/Server requests.
    
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
    
    var yourOwnProfile: Int? {
        
        get {
            
            return defaults.objectForKey("You") as? Int
            
        }
        
        set {
            
            defaults.setValue(newValue, forKey: "You")
            defaults.synchronize()
            
        }
        
    }
    
    //This information is used for login/registration/etc.
    
    var profileId: Int?
    
    var email: String!
    var username: String!
    var password: String!
    var registerID: Int!
    var loginID: String!
    var currentCreatingId: Int?
        
    func logOut() {
        
        email = ""
        username = ""
        password = ""
        
        token = nil
        
    }
    
    func registerWithCompletion(errorLabel: UILabel, completion: () -> Void) {
        
        var myErrorLabel = errorLabel
        
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
            
//            println(responseInfo)
            
            if let accessToken = responseInfo?["access_token"] as? String {
                
                self.token = accessToken
                
                if let id = responseInfo?["id"] as? Int {
                    
                    self.userId = id
                    
                    completion()
                    
                }
            
            }
            
            if let error = responseInfo?["errors"] as? [String] {
                
                myErrorLabel.text = error[0]
                println(error)
                
            }
            
        })
        
    }
    
    func login(errorLabel: UILabel, completion: () -> Void) {
        
        var myErrorLabel = errorLabel
        
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
                
                println("Here's my access token: \(accessToken)")
                self.token = accessToken
                
                if let id = responseInfo?["id"] as? Int {
                    
                    self.userId = id
                    
                }
                
                completion()
                
            }
            
            if let yourProfileInfo = responseInfo?["made_profile"] as? [String:AnyObject] {
                
                if let yourProfileId = yourProfileInfo["id"] as? Int {
                    
                    println("Your profile ID: \(yourProfileId)")
                    
                    self.yourOwnProfile = yourProfileId
                    
                }
                
            } else { self.yourOwnProfile = nil }
            
            println("Here's Your Own Profile status: \(self.yourOwnProfile)")
            
            if let error = responseInfo?["message"] as? String {
                
                myErrorLabel.text = error
                println(error)
                
            }
            
        })
        
    }
    
    func createProfile(completion: () -> Void) {
        
        let name = RecordedVideo.session().name!
        let email = RecordedVideo.session().email!
        let password = RecordedVideo.session().password!
        let birthyear = RecordedVideo.session().birthyear!
        let gender = RecordedVideo.session().gender!
        let orientation = RecordedVideo.session().orientation!
        let occupation = RecordedVideo.session().occupation!
        let location = RecordedVideo.session().location!
                
        var info = [
            
            "method" : "POST",
            "endpoint" : "/profiles",
            "parameters" : [
            
                "username": name,
                "email": email,
                "password": password,
                "birthyear": birthyear,
                "gender": gender,
                "orientation": orientation,
                "occupation": occupation,
                "location": location,
                
            ]
            
            ] as [String: AnyObject]
        
        println(info)
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println("Here's my response info for creating a new profile. \(responseInfo)")
            
            if let profiles = responseInfo?["profiles"] as? [String:AnyObject] {
                
                if let newId: Int = profiles["id"] as? Int {
                    
                    self.currentCreatingId = newId
                    
                    completion()
                
                }
                
            }
            
        })
        
    }
    

    func createVideo(videoType: String, videoURL: String, videoData: NSURL, thumbnailImage: UIImage, thumbnailURL: String, caption: String, completion: () -> Void) {
        
        let saveVideoThumbImage = thumbnailImage
        
        let currentProfileId = currentCreatingId!
        
        //Save videos for S3
        let saveVideoURL = S3_URL + videoURL
        let saveVideoThumb = S3_URL + thumbnailURL
        
//        println("Here's my profileID for the video endpoint: \(currentProfileId)")
        
        var info = [
            
            "method" : "POST",
            "endpoint" : "/profiles/\(currentProfileId)/videos",
            "parameters" : [
                
                "video_type": videoType,
                "video_url" : saveVideoURL,
                "thumbnail_url" : saveVideoThumb,
                "caption" : caption,
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println("Here's my post video response info! \(responseInfo)")
            
            if let responseURL = responseInfo?["video_url"] as? String {
                
                if responseURL == saveVideoURL {
                    
                    S3Request.session().saveVideoToS3(saveVideoThumbImage, thumbnailEndpoint: thumbnailURL, videoData: videoData, videoEndpoint: videoURL)
                    
                    completion()
                    
                }
                
            }
            
        })
        
    }
    
    func createAvatar(userGettingAvatar: Int, avatarEndpoint: String, completion: () -> Void) {
        
        var info = [
            
            "method" : "PUT",
            "endpoint" : "/profiles/\(userGettingAvatar)/avatar",
            "parameters" : [
                
                "avatar_remote_url" : S3_URL + avatarEndpoint
                
            ]
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println("Here's my response info for my Rails Create Avatar. \(responseInfo)")
            
            completion()
            
        })
        
    }
    
//    func updateProfile(completion: () -> Void) {
//
//        var info = [
//            
//            "method" : "PATCH",
//            "endpoint" : "/posts/new",
//            "parameters" : [
//                
//
//            ]
//            
//            ] as [String: AnyObject]
//        
//        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
//            
//        })
//        
//    }
    
    func getAllProfiles(completion: (profilesInfo: [String:AnyObject]) -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/profiles"
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            completion(profilesInfo: responseInfo as! [String:AnyObject])
//            println("Get all profiles response info: \(responseInfo)")
            
        })
        
    }
    
    func getSingleProfile(profileToGet: Int, completion: (profileInfo: [String:AnyObject]) -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/profiles/\(profileToGet)",
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println("Get single profile response info: \(responseInfo)")
            
            if let profile = responseInfo as? [String:AnyObject] {
                
                completion(profileInfo: profile)
                
            }
        })
        
    }
    
    func getYourCreatedProfiles(completion: (profiles: [[String:AnyObject]]) -> Void) {
        
        let myProfileId = userId!
        println(myProfileId)
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/users/\(myProfileId)/profiles",
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println("Here's my response info for fetched profiles. \(responseInfo)")
            
            if let profiles = responseInfo as? [[String:AnyObject]] {
            
                completion(profiles: profiles)

            }
            
        })
        
    }
    
    func searchProfiles(searchTerm: String, completion: (searchResults: [String:AnyObject]) -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/questions/search?keywords=\(searchTerm)",
            
            ] as [String: AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println("Search result response info: \(responseInfo)")
            
            completion(searchResults: responseInfo as! [String:AnyObject])
            
        })
        
    }
    
    func requestWithInfo(info: [String:AnyObject], andCompletion completion: ((responseInfo: AnyObject?) -> Void)?) {
        
        var endpoint = info["endpoint"] as! String
        
        // Query parameters for GET request
        if let query = info["query"] as? [String:AnyObject] {
            
            var first = true
            
            for (key,value) in query {
                
                // Choose sign if it's first ? else:
                var sign = first ? "?" : "&"
                
                endpoint = endpoint + "\(sign)\(key)=\(value)"
                
                // Set first the first time it runs:
                first = false
                
            }
            
        }
        
        if let url = NSURL(string: API_URL + endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = info["method"] as! String
            
            ///////HEADER
            
            if let token = token {
                
                request.setValue(token, forHTTPHeaderField: "Access-Token")
//                println("Here's my request value: \(request)")
                
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

                if data != nil {
                
                    if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                        
                        completion?(responseInfo: json)
                        
                    }
                    
                } else {
                    
                    completion?(responseInfo: nil)
                    
                }
                
            })
            
        }
        
    }
    
}
