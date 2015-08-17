//
//  YourMessagesDetailViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class YourMessagesDetailViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var videoView: RadiusView!
    @IBOutlet weak var avatarView: RadiusView!

    var videoURL: String!
    var videoThumbnail: String!
    var avatar: String?
    
    var name: String!
    var age: Int!
    var job: String!
    var city: String!
    var messageContents: String!
    var gender: String!
    var userID: Int!
    
    var messageSenderID: String!
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        
        launchPlayer(videoURL)
        
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        
        let messageReplyVC = storyboard?.instantiateViewControllerWithIdentifier("messageReplyVC") as! MessageReplyViewController
        
        messageReplyVC.sendingToId = userID
        messageReplyVC.sendingToName = name
        
        self.navigationController?.pushViewController(messageReplyVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if avatar != nil {
            
            avatarView.image = stringToImage(avatar!)
            
        }
        
        videoView.image = stringToImage(videoThumbnail)
        
        nameLabel.text = name
        ageLabel.text = "\(gender), \(age)"
        jobLabel.text = job
        cityLabel.text = city
        message.text = messageContents
        
        
//        if videoData != nil {
//            
//            vidPlayer = MPMoviePlayerController(contentURL: videoURL)
//            vidPlayer?.controlStyle = MPMovieControlStyle.None
//            vidPlayer?.view.frame = self.view.frame
//            vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
//            videoView.addSubview(vidPlayer!.view)
//            
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func stringToImage(imageToConvert: String) -> (UIImage) {
        
        let stringToURL = NSURL(string: imageToConvert)
        let imageData = NSData(contentsOfURL: stringToURL!)
        let finalImage = UIImage(data: imageData!)
        
        return finalImage!
        
    }
    
    func launchPlayer(videoToPlay: String) {
        
        let stringToURL = NSURL(string: videoToPlay)
        
        let takeVideoFlow = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = takeVideoFlow.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = stringToURL
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    

}







