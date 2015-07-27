//
//  ProfileMenuViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/6/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class ProfileMenuViewController: UITableViewController {

    var profilesToLoad: [[String:AnyObject]] = []
    var singleProfileInfo: [String:AnyObject] = [:]
    var myNewArray: [[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Rails Request that fetches the data.
        RailsRequest.session().getYourCreatedProfiles { (profiles) -> Void in
            
            self.profilesToLoad = profiles
            self.tableView.reloadData()
            println("These profiles loaded. \(profiles)")
            
        }
        
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        
        RailsRequest.session().currentCreatingId = nil
        RecordedVideo.session().resetSingleton()
        
        let createEditProfileNavVC = storyboard?.instantiateViewControllerWithIdentifier("createEditProfileNavVC") as! UINavigationController
        presentViewController(createEditProfileNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func editProfileButtonPressed(sender: UIButton) {
        
        let tag = sender.tag
        
        println("Tag: \(tag)")

        RailsRequest.session().currentCreatingId = sender.tag
        
        println("Current Creating ID: \(RailsRequest.session().currentCreatingId)")
        RecordedVideo.session().resetSingleton()
        
        let launchNavVC = storyboard?.instantiateViewControllerWithIdentifier("launchNavVC") as! UINavigationController
        
        presentViewController(launchNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
    
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        

        
        return profilesToLoad.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainMenuCell", forIndexPath: indexPath) as! ProfileMenuCell
        
        cell.profilePicture?.image = nil
        
        var timeInterval: NSTimeInterval = (0.5 + (NSTimeInterval(indexPath.row) * 0.1 ))
        
        cell.center.x += self.tableView.bounds.width
        
        UIView.animateWithDuration(timeInterval, animations: { () -> Void in
            
            cell.center.x -= self.tableView.bounds.width
            
        })
        
        if let profilePicURL = (self.profilesToLoad[indexPath.row]["avatar_remote_url"] as? String) ?? (self.profilesToLoad[indexPath.row]["avatar_url"] as? String) {

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                
                if profilePicURL != "/avatars/original/missing.png" ?? "/avatars/remote/missing.png" ?? "null" {
                    
                    let avatarURL = NSURL(string: profilePicURL)
                    let data = NSData(contentsOfURL: avatarURL!)
                    let avatarImage = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.profilePicture?.image = avatarImage
                        
                        })
                    
                }
              
                })
            
            if let profileName = self.profilesToLoad[indexPath.row]["username"] as? String {
                
                cell.nameLabel.text = profileName
                
            }
            
            if let profileId = self.profilesToLoad[indexPath.row]["id"] as? Int {
                
                cell.editButton.tag = profileId
                
            }
            
            }
                
        return cell
        
        }
    
}
