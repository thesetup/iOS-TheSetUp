//
//  ViewProfileController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 8/19/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class ViewProfileController: UITableViewController {
    
    @IBOutlet weak var profilePicView: RadiusView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexAndAgeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var interestedInLabel: UILabel!
    
    @IBOutlet weak var optional1: UILabel!
    @IBOutlet weak var optional2: UILabel!
    @IBOutlet weak var optional3: UILabel!
    
    @IBOutlet weak var mainVideoOutlet: RadiusView!
    @IBOutlet weak var optional1Outlet: RadiusView!
    @IBOutlet weak var optional2Outlet: RadiusView!
    @IBOutlet weak var optional3Outlet: RadiusView!
    
    @IBOutlet weak var mainVideoButton: UIButton!
    @IBOutlet weak var optional1Button: UIButton!
    @IBOutlet weak var optional2Button: UIButton!
    @IBOutlet weak var optional3Button: UIButton!
    
    
    var profileToLoad: Int!
    var videoURLArray: [String] = []
    var videoCaptions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainVideoButton.hidden = true
        optional1Button.hidden = true
        optional2Button.hidden = true
        optional3Button.hidden = true
        
        RailsRequest.session().getSingleProfile(profileToLoad, completion: { (profileInfo) -> Void in
            
            
            println("Search result info!")
            println(profileInfo)
            
            if let questions = profileInfo["question"] as? [String:AnyObject] {
                
                let gender = questions["gender"] as? String
                let birthyear = questions["birthyear"] as? Int
                let orientation = questions["orientation"] as? String
                
                self.sexAndAgeLabel.text = "\(gender!), \(2015 - birthyear!)"
                self.nameLabel.text = questions["name"] as? String
                self.locationLabel.text = questions["location"] as? String
                self.occupationLabel.text = questions["occupation"] as? String
                
                if orientation == "gay" {
                    
                    self.interestedInLabel.text = "Seeking: The Same Sex"
                    
                } else {
                    
                    self.interestedInLabel.text = "Seeking: The Opposite Sex"
                    
                }
                
            }
            
            if let mobileAvatarURL = profileInfo["avatar_remote_url"] as? String {
                
                if let convertToNSURL = NSURL(string: mobileAvatarURL) {
                    
                    let data = NSData(contentsOfURL: convertToNSURL)
                    let profilePic = UIImage(data: data!)
                    
                    self.profilePicView.image = profilePic
                    
                    
                }
                
            } else if let avatarURL = profileInfo["avatar_url"] as? String {
                
                if let convertToNSURL = NSURL(string: avatarURL) {
                    
                    let data = NSData(contentsOfURL: convertToNSURL)
                    let profilePic = UIImage(data: data!)
                    
                    self.profilePicView.image = profilePic
                    
                }
                
            }
            
            if let videos = profileInfo["videos"] as? [[String:AnyObject]] {
                
                if videos.count >= 1 {
                    
                    if let mainVideo = videos[0] as [String:AnyObject]? {
                        
                        let videoString = mainVideo["video_url"] as! String
                        self.videoURLArray.append(videoString)
                        
                        if let thumbnail = mainVideo["thumbnail_url"] as? String {
                            
                            let urlData = NSURL(string: thumbnail)
                            let thumbnailURL = NSData(contentsOfURL: urlData!)
                            let thumbnailImage = UIImage(data: thumbnailURL!)
                            
                            self.mainVideoOutlet.image = thumbnailImage
                            
                            self.mainVideoButton.hidden = false
                            
                        }
                        
                    } else { self.videoURLArray.append("None") }
                    
                }
                
                if videos.count >= 2 {
                    
                    if let optional1 = videos[1] as [String:AnyObject]? {
                        
                        let videoString = optional1["video_url"] as! String
                        self.videoURLArray.append(videoString)
                        self.optional1.text = (optional1["caption"] as! String) ?? "Optional 2"
                        
                        if let thumbnail = optional1["thumbnail_url"] as? String {
                            
                            let urlData = NSURL(string: thumbnail)
                            let thumbnailURL = NSData(contentsOfURL: urlData!)
                            let thumbnailImage = UIImage(data: thumbnailURL!)
                            
                            self.optional1Outlet.image = thumbnailImage
                            
                            self.optional1Button.hidden = false
                            
                        }
                        
                    } else { self.videoURLArray.append("None") }
                    
                }
                
                if videos.count >= 3 {
                    
                    if let optional2 = videos[2] as [String:AnyObject]?  {
                        
                        let videoString = optional2["video_url"] as! String
                        self.videoURLArray.append(videoString)
                        self.optional2.text = (optional2["caption"] as! String) ?? "Optional 2"
                        
                        if let thumbnail = optional2["thumbnail_url"] as? String {
                            
                            let urlData = NSURL(string: thumbnail)
                            let thumbnailURL = NSData(contentsOfURL: urlData!)
                            let thumbnailImage = UIImage(data: thumbnailURL!)
                            
                            self.optional2Outlet.image = thumbnailImage
                            
                            self.optional2Button.hidden = false
                            
                        }
                        
                        
                    } else { self.videoURLArray.append("None") }
                    
                }
                
                if videos.count >= 4 {
                    
                    if let optional3 = videos[3] as [String:AnyObject]? {
                        
                        let videoString = optional3["video_url"] as! String
                        self.videoURLArray.append(videoString)
                        self.optional3.text = (optional3["caption"] as! String) ?? "Optional 3"
                        
                        if let thumbnail = optional3["thumbnail_url"] as? String {
                            
                            let urlData = NSURL(string: thumbnail)
                            let thumbnailURL = NSData(contentsOfURL: urlData!)
                            let thumbnailImage = UIImage(data: thumbnailURL!)
                            
                            self.optional3Outlet.image = thumbnailImage
                            
                            self.optional3Button.hidden = false
                            
                        }
                        
                        
                    } else { self.videoURLArray.append("None") }
                    
                }
                
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
    
    func launchPlayer(videoToPlay: String) {
        
        let videoURL = NSURL(string: videoToPlay)
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = videoStoryboard.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = videoURL
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

