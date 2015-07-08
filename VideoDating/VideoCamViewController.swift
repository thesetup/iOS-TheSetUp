//
//  VideoCamViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class VideoCamViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var flipButton: CustomButton!

    let videoPick = UIImagePickerController()
    let libraryPick = UIImagePickerController()
    
    var videoData: NSData?
    
    var vidPlayer: MPMoviePlayerController?
    var vidPreview: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopButton.hidden = true
        
        videoPick.sourceType = .Camera
        videoPick.cameraCaptureMode = .Video
        videoPick.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        videoPick.delegate = self
        videoPick.allowsEditing = true
        videoPick.showsCameraControls = false
        videoPick.mediaTypes = [kUTTypeMovie]
        videoPick.view.frame = videoView.frame
        videoView.addSubview(videoPick.view)
        
        // Do any additional setup after loading the view.
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("Here's my Info from the VideoCamViewController: \(info)")
        
        let vidURL = info[UIImagePickerControllerMediaURL] as! NSURL
        videoData = NSData(contentsOfURL: vidURL)
        
        vidPlayer = MPMoviePlayerController(contentURL: vidURL)
        vidPlayer?.controlStyle = MPMovieControlStyle.None
        vidPlayer?.view.frame = videoView.frame
        vidPlayer?.scalingMode = MPMovieScalingMode.AspectFill
        vidPlayer?.view.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func takeVideo() {
        
        self.videoPick.videoMaximumDuration = 60
        self.videoPick.startVideoCapture()
        
    }
    
    func playVid() {
        
        vidPlayer?.play()
        
        // Code to hide/animate away the button when playback starts.  
                
    }
    
    
    @IBAction func recordButtonPressed(sender: AnyObject) {
        
        startButton.hidden = true
        stopButton.hidden = false
        
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
    
        stopButton.hidden = true
        startButton.hidden = false
    
    }
    
    @IBAction func loadButtonPressed(sender: AnyObject) {
        
        libraryPick.sourceType = .PhotoLibrary
        
    }
    
    @IBAction func flipButtonPressed(sender: AnyObject) {
        
        
        
    }
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        imagePickerControllerDidCancel(videoPick)
        
    }
    
    @IBAction func playRecordedVideoButtonPressed(sender: AnyObject) {
    
    
    
    }
    
    @IBAction func retryButtonPressed(sender: AnyObject) {
    
    
    
    }

}








