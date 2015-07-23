//
//  VideoCamResultViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/3/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class SaveVideoViewController: UIViewController {
    
    @IBOutlet weak var capturedVideo: UIView!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var videoStillView: UIImageView!
    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var retryButton: OutlineButton!
    @IBOutlet weak var saveButton: OutlineButton!

    var timeyNumber = Int(NSDate().timeIntervalSince1970)
    
    var vidPlayer: MPMoviePlayerController?
    
    // These properties are all set from the previous view controller.
    var videoURL: NSURL!
    var thumbnailImage: UIImage!
    var videoStillImage: UIImage!
    var videoType: VideoTypes!
    var videoString: String!
    
    var hobbiesTastes: [String:AnyObject]?
    
    var videoName: String {
        return "/\(videoString)_\(timeyNumber).mp4"
    }
    
    var videoFile: String {
        return documentsDirectory + videoName
    }
    
    var resizedVideoURL: NSURL? {
        return NSURL(fileURLWithPath: videoFile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            self.view.setNeedsUpdateConstraints()
            self.view.setNeedsLayout()
            
            if let kbSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size{
                
                self.bottomConstraint.constant = 20 + kbSize.height
                
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            self.bottomConstraint.constant = 20
            
        }
        
        if videoType == VideoTypes.MainVideo {
            
            videoTitle.hidden = true
            
        }
        
        vidPlayer = MPMoviePlayerController(contentURL: videoURL)
        vidPlayer?.controlStyle = MPMovieControlStyle.None
        vidPlayer?.view.frame = self.view.frame
        vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
        capturedVideo.addSubview(vidPlayer!.view)
        
        videoStillView.image = videoStillImage!
        
        stopButton.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        retryButton.center.x -= view.bounds.height
        playButton.center.y += view.bounds.height
        stopButton.center.y += view.bounds.height
        videoTitle.center.y += view.bounds.height
        saveButton.center.y += view.bounds.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.retryButton.center.x += self.view.bounds.height
            self.playButton.center.y -= self.view.bounds.height
            self.stopButton.center.y -= self.view.bounds.height
            self.videoTitle.center.y -= self.view.bounds.height
            self.saveButton.center.y -= self.view.bounds.height
            
        })
        
    }
    
    func convertVideoQuality(completion: (() -> ())?) {
        
        let videoAsset = AVURLAsset(URL: videoURL, options: nil)
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetMediumQuality)
        exportSession.outputURL = resizedVideoURL
        exportSession.outputFileType = AVFileTypeMPEG4
        exportSession.exportAsynchronouslyWithCompletionHandler { () -> Void in
            
            println("My convert video completion is running.")
            if let c = completion { c() }
            
        }
        
    }
    
    func saveVideoToSingleton() {
        
        let videoLabel = videoTitle.text
        var videoEndpoint = "\(videoString)_\(timeyNumber).mp4"
        var thumbnailEndpoint = "thumbnail_\(videoString)_\(timeyNumber).png"
        
        println(videoLabel)
        println(videoEndpoint)
        println(thumbnailEndpoint)
        println("Here's the video I'm trying to convert. \(resizedVideoURL)")
        
        if videoType != nil {
            
            switch videoType! {
                
            case .MainVideo :
                
                RecordedVideo.session().mainVideoURL = resizedVideoURL
                RecordedVideo.session().mainVideoLink = videoEndpoint
                RecordedVideo.session().mainVideoThumbnail = thumbnailImage
                RecordedVideo.session().mainVideoThumbnailLink = thumbnailEndpoint
                
            case .Optional1 :
                
                RecordedVideo.session().optionalVideo1URL = resizedVideoURL
                RecordedVideo.session().optionalVideo1Link = videoEndpoint
                RecordedVideo.session().optionalVideo1Thumbnail = thumbnailImage
                RecordedVideo.session().optionalVideo1ThumbnailLink = thumbnailEndpoint
                RecordedVideo.session().optionalVideo1Label = videoTitle.text
                
            case .Optional2 :
                
                RecordedVideo.session().optionalVideo2URL = resizedVideoURL
                RecordedVideo.session().optionalVideo2Link = videoEndpoint
                RecordedVideo.session().optionalVideo2Thumbnail = thumbnailImage
                RecordedVideo.session().optionalVideo2ThumbnailLink = thumbnailEndpoint
                RecordedVideo.session().optionalVideo2Label = videoTitle.text
                
            case .Optional3 :
                
                RecordedVideo.session().optionalVideo3URL = resizedVideoURL
                RecordedVideo.session().optionalVideo3Link = videoEndpoint
                RecordedVideo.session().optionalVideo3Thumbnail = thumbnailImage
                RecordedVideo.session().optionalVideo3ThumbnailLink = thumbnailEndpoint
                RecordedVideo.session().optionalVideo3Label = videoTitle.text

            default:
                
                break
                
            }
            
        } else {
            
            println("Problem: Your videoType is nil for some reason.")
            
        }
        
    }
    
    @IBAction func playVid(sender: AnyObject) {
        
        videoStillView?.hidden = true
        
        playButton.hidden = true
        stopButton.hidden = false
        vidPlayer?.play()
        
    }
    
    @IBAction func stopVid(sender: AnyObject) {
        
        videoStillView?.hidden = false
        
        playButton.hidden = false
        stopButton.hidden = true
        vidPlayer?.stop()
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        let saveAlert = UIAlertController(title: "Save Video", message: "Do you want to save this video?", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (action: UIAlertAction!) -> Void in
            
            self.convertVideoQuality({ () -> () in
                
                self.saveVideoToSingleton()
                
                self.dismissViewControllerAnimated(true, completion: nil)

            })
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        saveAlert.addAction(confirmAction)
        saveAlert.addAction(cancelAction)
     
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    
}