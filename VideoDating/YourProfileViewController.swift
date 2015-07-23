//
//  YourProfileViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class YourProfileViewController: UITableViewController {

    @IBOutlet weak var profilePictureView: RadiusView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexAndAgeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var interestedInLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    
    @IBOutlet weak var optional1: UILabel!
    @IBOutlet weak var optional2: UILabel!
    @IBOutlet weak var optional3: UILabel!
    
    @IBOutlet weak var mainVideoOutlet: RadiusView!
    @IBOutlet weak var optional1Outlet: RadiusView!
    @IBOutlet weak var optional2Outlet: RadiusView!
    @IBOutlet weak var optional3Outlet: RadiusView!
    
    var loadingFromId: Int!
    var videoURLArray: [String] = []
    var videoCaptions: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RailsRequest.session().getSingleProfile(loadingFromId, completion: { (profileInfo) -> Void in
            
            if let questions = profileInfo["question"] as? [String:AnyObject] {
                
                let gender = questions["gender"] as? String
                let birthyear = questions["birthyear"] as? Int
                let orientation = questions["orientation"] as? String
                
                self.sexAndAgeLabel.text = "\(gender!), \(2015 - birthyear!)"
                self.nameLabel.text = questions["name"] as? String
                self.locationLabel.text = questions["location"] as? String
                self.occupationLabel.text = questions["occupation"] as? String
                
                if orientation == "Straight" {
                    
                    self.interestedInLabel.text = "Seeking: The Opposite Sex"
                    
                } else {
                    
                    self.interestedInLabel.text = "Seeking: The Same Sex"
                    
                }
                
            }
            
            if let mobileAvatarURL = profileInfo["avatar_remote_url"] as? String {
                
                if let convertToNSURL = NSURL(string: mobileAvatarURL) {
                    
                    let data = NSData(contentsOfURL: convertToNSURL)
                    let profilePic = UIImage(data: data!)
                    
                    self.profilePictureView.image = profilePic
                    
                    
                }
                
            } else if let avatarURL = profileInfo["avatar_url"] as? String {
                
                if let convertToNSURL = NSURL(string: avatarURL) {
                    
                    let data = NSData(contentsOfURL: convertToNSURL)
                    let profilePic = UIImage(data: data!)
                    
                    self.profilePictureView.image = profilePic
                    
                }
                
            }
            
            if let videos = profileInfo["videos"] as? [[String:AnyObject]] {
                
                if let mainVideo = videos[0] as [String:AnyObject]? {
                    
                    let videoString = mainVideo["video_url"] as! String
                    self.videoURLArray.append(videoString)
                    
                    if let thumbnail = mainVideo["thumbnail_url"] as? String {
                        
                        let urlData = NSURL(string: thumbnail)
                        let thumbnailURL = NSData(contentsOfURL: urlData!)
                        let thumbnailImage = UIImage(data: thumbnailURL!)
                        
                        self.mainVideoOutlet.image = thumbnailImage
                        
                    }
                    
                } else { self.videoURLArray.append("None") }
                
                if let optional1 = videos[1] as [String:AnyObject]? {
                    
                    let videoString = optional1["video_url"] as! String
                    self.videoURLArray.append(videoString)
                    self.optional1.text = (optional1["caption"] as! String) ?? "Optional 2"
                    
                    if let thumbnail = optional1["thumbnail_url"] as? String {
                        
                        let urlData = NSURL(string: thumbnail)
                        let thumbnailURL = NSData(contentsOfURL: urlData!)
                        let thumbnailImage = UIImage(data: thumbnailURL!)
                        
                        self.optional1Outlet.image = thumbnailImage
                        
                    }
                    
                } else { self.videoURLArray.append("None") }
                
                if let optional2 = videos[2] as [String:AnyObject]?  {
                    
                    let videoString = optional2["video_url"] as! String
                    self.videoURLArray.append(videoString)
                    self.optional2.text = (optional2["caption"] as! String) ?? "Optional 2"
                    
                    if let thumbnail = optional2["thumbnail_url"] as? String {
                        
                        let urlData = NSURL(string: thumbnail)
                        let thumbnailURL = NSData(contentsOfURL: urlData!)
                        let thumbnailImage = UIImage(data: thumbnailURL!)
                        
                        self.optional2Outlet.image = thumbnailImage
                        
                    }
                    
                    
                } else { self.videoURLArray.append("None") }
                
                if let optional3 = videos[3] as [String:AnyObject]? {
                    
                    let videoString = optional3["video_url"] as! String
                    self.videoURLArray.append(videoString)
                    self.optional3.text = (optional3["caption"] as! String) ?? "Optional 3"
                    
                    if let thumbnail = optional3["thumbnail_url"] as? String {
                        
                        let urlData = NSURL(string: thumbnail)
                        let thumbnailURL = NSData(contentsOfURL: urlData!)
                        let thumbnailImage = UIImage(data: thumbnailURL!)
                        
                        self.optional3Outlet.image = thumbnailImage
                        
                    }
                    
                    
                } else { self.videoURLArray.append("None") }
                
            }
            
        })
    
    }

    @IBAction func mainVideoPressed(sender: AnyObject) {
        
        if videoURLArray[0] != "None" {
            
            let URL = videoURLArray[0]
            launchPlayer(URL)
            
        }
        
    }
    
    @IBAction func optional1Pressed(sender: AnyObject) {
        
        if videoURLArray[1] != "None" {
            
            let URL = videoURLArray[1]
            launchPlayer(URL)
            
        }
        
    }
    
    @IBAction func optional2Pressed(sender: AnyObject) {
        
        if videoURLArray[2] != "None" {
            
            let URL = videoURLArray[2]
            launchPlayer(URL)
            
        }
        
    }
    
    @IBAction func optional3Pressed(sender: AnyObject) {
        
        if videoURLArray[3] != "None" {
            
            let URL = videoURLArray[3]
            launchPlayer(URL)
            
        }
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func launchPlayer(videoToPlay: String) {
        
        let stringToURL = NSURL(string: videoToPlay)
        
        let takeVideoFlow = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = takeVideoFlow.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = stringToURL
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    // MARK: - Collection View Data Source
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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