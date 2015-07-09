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
    
    
    var vidPlayer: MPMoviePlayerController?
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vidPlayer = MPMoviePlayerController(contentURL: videoURL)
        vidPlayer?.controlStyle = MPMovieControlStyle.None
        vidPlayer?.view.frame = self.view.frame
        vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
        capturedVideo.addSubview(vidPlayer!.view)
        
        videoStillView.image = videoStillImage
        
        stopButton.hidden = true
        
    }
    
    func convertVideoQuality(completion: (() -> ())?) {
        
        let videoAsset = AVURLAsset(URL: videoURL, options: nil)
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetMediumQuality)
        println(S3Request.session().resizedVideoURL)
        exportSession.outputURL = S3Request.session().resizedVideoURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.exportAsynchronouslyWithCompletionHandler { () -> Void in
            
            if let c = completion { c() }
            
        }
        
    }
    
    func saveToS3() {
        
        S3Request.session().thumbnail = videoStillImage
        
        convertVideoQuality { () -> () in
            
            S3Request.session().saveVideoToS3()
            
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
            
            self.saveToS3()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        saveAlert.addAction(confirmAction)
        saveAlert.addAction(cancelAction)
     
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    
}