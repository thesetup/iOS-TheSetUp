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
        
        RailsRequest.session().getYourCreatedProfiles { (profiles) -> Void in
            
            self.profilesToLoad = profiles
            self.tableView.reloadData()
            
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
        
        RailsRequest.session().currentCreatingId = sender.tag
        RecordedVideo.session().resetSingleton()
       
        let launchNavVC = storyboard?.instantiateViewControllerWithIdentifier("launchNavVC") as! UINavigationController
        
        (launchNavVC.viewControllers[0] as! LaunchViewController).userId = sender.tag
        
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
        
        if let profilePicURL = profilesToLoad[indexPath.row]["avatar_url"] as? String {
            
            if profilePicURL != "/avatars/original/missing.png" {
                
                let avatarURL = NSURL(string: profilePicURL)
                let data = NSData(contentsOfURL: avatarURL!)
                let avatarImage = UIImage(data: data!)
                
                cell.profilePicture?.image = avatarImage
                
            }
            
        }
        
        if let profileName = profilesToLoad[indexPath.row]["username"] as? String {
        
            cell.nameLabel.text = profileName
        
        }
        
        if let profileId = profilesToLoad[indexPath.row]["id"] as? Int {
            
            cell.editButton.tag = profileId
            
        }
        
        
          return cell
        
        }
    
}
