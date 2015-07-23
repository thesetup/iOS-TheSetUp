//
//  EditVideosViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/15/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class EditVideosViewController: UITableViewController {
    
    // Main Video :: 1 Minute
    @IBOutlet weak var mainVideo: RadiusView!
    @IBOutlet weak var addMainVideo: UIButton!
    
    // Optional Video 1
    @IBOutlet weak var optionalVideo1: RadiusView!
    @IBOutlet weak var addOptionalVideo1: UIButton!
    @IBOutlet weak var optionalLabel1: UILabel!
    
    // Optional Video 2
    @IBOutlet weak var optionalVideo2: RadiusView!
    @IBOutlet weak var addOptionalVideo2: UIButton!
    @IBOutlet weak var optionalLabel2: UILabel!
    
    // Optional Video 3
    @IBOutlet weak var optionalVideo3: RadiusView!
    @IBOutlet weak var addOptionalVideo3: UIButton!
    @IBOutlet weak var optionalLabel3: UILabel!
    
    // Optional variable for info. Set this when instantiating this VC from the Profile Menu Table View ONLY.
    var loadingFromId = RailsRequest.session().currentCreatingId as Int?
    
    var profilesToLoad: [[String:AnyObject]] = []
    var mediaToPlay: String?
    
    override func viewWillAppear(animated: Bool) {
        
        if RecordedVideo.session().mainVideoThumbnail != nil {
            
            mainVideo.image = RecordedVideo.session().mainVideoThumbnail
            addMainVideo.titleLabel?.hidden = true
            
        }
        
        if RecordedVideo.session().optionalVideo1Thumbnail != nil {
            
            optionalVideo1.image = RecordedVideo.session().optionalVideo1Thumbnail
            addOptionalVideo1.titleLabel?.hidden = true
            optionalLabel1.text = RecordedVideo.session().optionalVideo1Label
            
        }
        
        if RecordedVideo.session().optionalVideo2Thumbnail != nil {
            
            optionalVideo2.image = RecordedVideo.session().optionalVideo2Thumbnail
            addOptionalVideo2.titleLabel?.hidden = true
            optionalLabel2.text = RecordedVideo.session().optionalVideo2Label
            
        }
        
        if RecordedVideo.session().optionalVideo3Thumbnail != nil {
            
            optionalVideo3.image = RecordedVideo.session().optionalVideo3Thumbnail
            addOptionalVideo3.titleLabel?.hidden = true
            optionalLabel3.text = RecordedVideo.session().optionalVideo3Label
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        if loadingFromId != nil {
        
//            RecordedVideo.session().loadRailsInfoToSingleton(loadingFromId!)
//            
//            mainVideo.image = RecordedVideo.session().mainVideoThumbnail
//            addMainVideo.titleLabel!.hidden = true
//            
//            optionalVideo1.image = RecordedVideo.session().optionalVideo1Thumbnail
//            addOptionalVideo1.titleLabel!.hidden = true
//            
//            optionalVideo2.image = RecordedVideo.session().optionalVideo2Thumbnail
//            addOptionalVideo2.titleLabel!.hidden = true
//            
//            optionalVideo3.image = RecordedVideo.session().optionalVideo3Thumbnail
//            addOptionalVideo3.titleLabel!.hidden = true
            
//        }
        
    }
    
    func convertURLtoViewImage(stringToConvert: String, viewToAddImage: RadiusView) {
        
        if let newURL = NSURL(string: stringToConvert) {
            
            let newUIImage = UIImage(data: NSData(contentsOfURL: newURL)!)
            viewToAddImage.image = newUIImage
            
        }
        
    }
    
    @IBAction func addMainVideoButtonPressed(sender: AnyObject) {
        
        beginVideoRecording(.MainVideo, videoString: "mainVideo", videoLength: 60)
        
    }
    
    @IBAction func addVideo1ButtonPressed(sender: AnyObject) {
        
        beginVideoRecording(.Optional1, videoString: "optional1", videoLength: 30)
        
    }
    
    @IBAction func addVideo2ButtonPressed(sender: AnyObject) {
        
        beginVideoRecording(.Optional2, videoString: "optional2", videoLength: 30)
        
    }
    
    @IBAction func addVideo3ButtonPressed(sender: AnyObject) {
        
        beginVideoRecording(.Optional3, videoString: "optional3", videoLength: 30)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        let submitAlert = UIAlertController(title: "Warning", message: "Are you sure? Videos will not be saved to profile.", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction!) -> Void in
            
            RecordedVideo.session().resetSingleton()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        submitAlert.addAction(confirmAction)
        submitAlert.addAction(cancelAction)
        
        presentViewController(submitAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        //Make RailsRequest to save data.
        if loadingFromId != nil {
            
            RailsRequest.session().profileId = loadingFromId!
            
        }
        
        if RecordedVideo.session().mainVideoURL != nil {
            
            RailsRequest.session().createVideo("main_video", videoURL: RecordedVideo.session().mainVideoLink!, videoData: RecordedVideo.session().mainVideoURL!, thumbnailImage:  RecordedVideo.session().mainVideoThumbnail!, thumbnailURL: RecordedVideo.session().mainVideoThumbnailLink!, caption: "", completion: { () -> Void in
                
//                println("Here's my video NSURL data. \(RecordedVideo.session().mainVideoURL!) ")
                
            })
            
            }
        
            if RecordedVideo.session().optionalVideo1URL != nil {
                
                RailsRequest.session().createVideo("optional_video_1", videoURL: RecordedVideo.session().optionalVideo1Link!, videoData: RecordedVideo.session().optionalVideo1URL!, thumbnailImage: RecordedVideo.session().optionalVideo1Thumbnail!, thumbnailURL: RecordedVideo.session().optionalVideo1ThumbnailLink!, caption: RecordedVideo.session().optionalVideo1Label!, completion: { () -> Void in
                    
                })
                
            }
            
            if RecordedVideo.session().optionalVideo2URL != nil {
                
                RailsRequest.session().createVideo("optional_video_2", videoURL: RecordedVideo.session().optionalVideo2Link!, videoData: RecordedVideo.session().optionalVideo2URL!, thumbnailImage: RecordedVideo.session().optionalVideo2Thumbnail!, thumbnailURL: RecordedVideo.session().optionalVideo2ThumbnailLink!, caption: RecordedVideo.session().optionalVideo2Label!, completion: { () -> Void in
                    
                })
                
            }
            
            if RecordedVideo.session().optionalVideo3URL != nil {
                
                RailsRequest.session().createVideo("optional_video_3", videoURL: RecordedVideo.session().optionalVideo3Link!, videoData: RecordedVideo.session().optionalVideo3URL!, thumbnailImage: RecordedVideo.session().optionalVideo3Thumbnail!, thumbnailURL: RecordedVideo.session().optionalVideo3ThumbnailLink!, caption: RecordedVideo.session().optionalVideo3Label!, completion: { () -> Void in
                    
                })
                
            }
            
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func beginVideoRecording(videoCategory: VideoTypes, videoString: String, videoLength: Int) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoCamNavVC = videoStoryboard.instantiateViewControllerWithIdentifier("videoCamNavVC") as! UINavigationController
        
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoDuration = videoLength
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoType = videoCategory
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoString = videoString
        
        presentViewController(videoCamNavVC, animated: true, completion: nil)
        
    }
    
    func launchVideoPlayer(videoToPlay: NSURL) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = videoStoryboard.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = videoToPlay
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
    }
    
}