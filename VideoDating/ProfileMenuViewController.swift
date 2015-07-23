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
        
        // Rails Request that fetches the data.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        RailsRequest.session().getYourCreatedProfiles { (profiles) -> Void in
            
            self.profilesToLoad = profiles
            self.tableView.reloadData()
            println("Data Reloaded!!")
            
            println("Here's what should be going into my ProfileMenuViewController!!!!!!!!")
            println(self.profilesToLoad)
            
        }
        
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        
        RailsRequest.session().currentCreatingId = nil
        RecordedVideo.session().resetSingleton()
        
        let createEditProfileNavVC = storyboard?.instantiateViewControllerWithIdentifier("createEditProfileNavVC") as! UINavigationController
        presentViewController(createEditProfileNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func editProfileButtonPressed(sender: UIButton) {
        
        println(sender.tag)
        
        if let tag = sender.tag as? Int {
            
            RailsRequest.session().currentCreatingId = sender.tag
            
            
            println(RailsRequest.session().currentCreatingId)
            RecordedVideo.session().resetSingleton()
            
            let launchNavVC = storyboard?.instantiateViewControllerWithIdentifier("launchNavVC") as! UINavigationController
            
            presentViewController(launchNavVC, animated: true, completion: nil)
            
        }
        
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
        
        if let profilePicURL = (self.profilesToLoad[indexPath.row]["avatar_remote_url"] as? String) ?? (self.profilesToLoad[indexPath.row]["avatar_url"] as? String) {

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                
                if profilePicURL != "/avatars/original/missing.png" {
                    
                    let avatarURL = NSURL(string: profilePicURL)
                    let data = NSData(contentsOfURL: avatarURL!)
                    let avatarImage = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.profilePicture?.image = avatarImage
                        
                        println("My Dispatch Main Queue is running.")
                        
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
