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

        var query = PFQuery(className: "User\(RailsRequest.session().yourOwnProfile)")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                
                println("Uh oh, there's an error: \(error)")
                
            }
            
            if objects != nil {
                
                if let messages = objects as? [PFObject] {
                  
                    for message in messages {
                        
                        let profileId = message.objectForKey("sentBy") as! Int
                        
                        RailsRequest.session().getSingleProfile(profileId, completion: { (profileInfo) -> Void in
                            
                            if let questions = profileInfo["question"] as? [String:AnyObject] {
                                
                                let name = questions["name"] as? String
                                let gender = questions["gender"] as? String
                                let age = (2015 - (questions["birthyear"] as? Int)!)
                                let location = questions["location"] as? String
                                let mobileAvatarURL = profileInfo["avatar_remote_url"] as? String
                                let desktopAvatarURL = profileInfo["avatar_url"] as? String
                                
                                let newMessageItem = [
                                
                                    "name": name!,
                                    "gender": gender!,
                                    "age": age,
                                    "location": location!,
                                    "mobileAvatar": mobileAvatarURL!,
                                    "desktopAvatar": desktopAvatarURL!,
                                    
                                ] as [String:AnyObject]
                                
                                self.myMessages.append(newMessageItem)
                                
//                                self.sexAndAgeLabel.text = "\(gender!), \(2015 - birthyear!)"
//                                self.nameLabel.text = questions["name"] as? String
//                                self.locationLabel.text = questions["location"] as? String
//                                self.occupationLabel.text = questions["occupation"] as? String
                                
                            }
                            
//                            if let mobileAvatarURL = profileInfo["avatar_remote_url"] as? String {
//                                
//                                if let convertToNSURL = NSURL(string: mobileAvatarURL) {
//                                    
//                                    let data = NSData(contentsOfURL: convertToNSURL)
//                                    let profilePic = UIImage(data: data!)
//                                    
//                                    self.profilePicView.image = profilePic
//                                    
//                                    
//                                }
//                                
//                            } else if let avatarURL = profileInfo["avatar_url"] as? String {
//                                
//                                if let convertToNSURL = NSURL(string: avatarURL) {
//                                    
//                                    let data = NSData(contentsOfURL: convertToNSURL)
//                                    let profilePic = UIImage(data: data!)
//                                    
//                                    self.profilePicView.image = profilePic
//                                    
//                                }
//                                
//                            }
                            
                            
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
        let cell = tableView.dequeueReusableCellWithIdentifier("applicationsCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */


}
