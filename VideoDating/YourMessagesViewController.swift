//
//  YourMessagesViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import Parse
import Bolts

class YourMessagesViewController: UITableViewController {
    
    var myMessages: [[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFQuery(className: "Profile\(RailsRequest.session().yourOwnProfile!)")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                println("Uh oh, there's an error: \(error)")
                
            }
            
            if objects != nil {
                
                if let messages = objects as? [PFObject] {
                
                    println("Here are my messages PFObjects.")
                    println(messages)
                    
                    for message in messages {
                        
                        println("Message \(message)")
                        
                        let profileId = message.objectForKey("sentBy") as! Int
                        
                        RailsRequest.session().getSingleProfile(profileId, completion: { (profileInfo) -> Void in
                            
                            if let questions = profileInfo["question"] as? [String:AnyObject] {
                                
                                let senderId = message["sentBy"] as? String
                                let name = questions["name"] as? String
                                let gender = questions["gender"] as? String
                                let age = (2015 - (questions["birthyear"] as? Int)!)
                                let location = questions["location"] as? String
                                let job = questions["occupation"] as? String
                                let date = message["dateInfo"] as? String
                                var userID = 0
                                
                                if let profileSection = profileInfo["profiles"] as? [String:AnyObject] {
                                    
                                    userID = profileSection["id"] as! Int
                                    
                                }
                                
                                println(userID)
                                
                                let textMessage = message["textMessage"] as? String
                                let videoLink = message["videoThumbnail"] as? String
                                let videoThumbnail = message["videoURL"] as? String
                                
                                let mobileAvatarURL = profileInfo["avatar_remote_url"] as? String
                                let desktopAvatarURL = profileInfo["avatar_url"] as? String
                                
                                
                                let newMessageItem = [
                                
                                    "name": name!,
                                    "gender": gender!,
                                    "age": age,
                                    "location": location!,
                                    "job": job!,
                                    "mobileAvatar": mobileAvatarURL!,
                                    "desktopAvatar": desktopAvatarURL!,
                                    "date": date!,
                                    "userID": userID,
                                    "messageContents": [
                                    
                                        "textMessage": textMessage!,
                                        "videoLink": videoLink!,
                                        "videoThumbnail": videoThumbnail!
                                    
                                    ]
                                    
                                ] as [String:AnyObject]
                                
                                self.myMessages.append(newMessageItem)
                                
                                println("My Messages!")
                                println(self.myMessages)
                                
                                self.tableView.reloadData()
                                
                            }
                            
                            
                        })

                    }
                    
                }
                
            }
            
        }
        
        
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return myMessages.count
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myMessages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("applicationsCell", forIndexPath: indexPath) as! ApplicationsTableViewCell
        
        var timeInterval: NSTimeInterval = (0.5 + (NSTimeInterval(indexPath.row) * 0.1 ))
        
        cell.center.x += self.tableView.bounds.width
        
        UIView.animateWithDuration(timeInterval, animations: { () -> Void in
            
            cell.center.x -= self.tableView.bounds.width
            
        })
        
        if let profilePicURL = (myMessages[indexPath.row]["mobileAvatar"] as? String) ?? (myMessages[indexPath.row]["desktopAvatar"] as? String) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                
                if profilePicURL != "/avatars/original/missing.png" ?? "/avatars/remote/missing.png" ?? "null" {
                    
                    let avatarURL = NSURL(string: profilePicURL)
                    let data = NSData(contentsOfURL: avatarURL!)
                    let avatarImage = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.profilePicView.image = avatarImage
                        
                    })
                    
                }
                
            })
            
        }
        
        let name = myMessages[indexPath.row]["name"] as! String
        let age = myMessages[indexPath.row]["age"] as! Int
        let location = myMessages[indexPath.row]["location"] as! String
        let theDate = myMessages[indexPath.row]["date"] as! String
        let gender = myMessages[indexPath.row]["gender"] as! String
        
        cell.profileNameLabel.text = "\(name)"
        cell.locationLabel.text = "\(gender), \(age), \(location)"
        cell.dateLabel.text = "\(theDate)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("yourMessagesDetailVC") as! YourMessagesDetailViewController
        
        let name = myMessages[indexPath.row]["name"] as! String
        let age = myMessages[indexPath.row]["age"] as! Int
        let gender = myMessages[indexPath.row]["gender"] as! String
        let location = myMessages[indexPath.row]["location"] as! String
        let theDate = myMessages[indexPath.row]["date"] as! String
        let job = myMessages[indexPath.row]["job"] as! String
        let avatar = myMessages[indexPath.row]["mobileAvatar"] as? String ?? myMessages[indexPath.row]["desktopAvatar"] as! String
        
        let userID = myMessages[indexPath.row]["userID"] as! Int
        
        detailVC.name = name
        detailVC.age = age
        detailVC.city = location
        detailVC.job = job
        detailVC.avatar = avatar
        detailVC.gender = gender
        detailVC.userID = userID
        
        if let messageContents = myMessages[indexPath.row]["messageContents"] as? [String:String] {
            
            let message = messageContents["textMessage"]
            let url = messageContents["videoLink"]
            let thumbnail = messageContents["videoThumbnail"]
            
            detailVC.messageContents = message
            detailVC.videoURL = url
            detailVC.videoThumbnail = thumbnail
            
        }
        
        if detailVC.videoURL != nil {
            
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }
        
        
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}








