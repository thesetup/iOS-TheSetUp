//
//  PlayVideoViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class PlayVideoViewController: UIViewController {
    
    @IBOutlet weak var loadedVideo: UIView!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var stopButton: CustomButton!
    
    var vidPlayer: MPMoviePlayerController?
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vidPlayer = MPMoviePlayerController(contentURL: videoURL)
        vidPlayer?.controlStyle = MPMovieControlStyle.None
        vidPlayer?.view.frame = self.view.frame
        vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
        loadedVideo.addSubview(vidPlayer!.view)
        
        playButton.hidden = true
        vidPlayer?.play()
        
    }
    
    @IBAction func playVid(sender: AnyObject) {
        
        playButton.hidden = true
        stopButton.hidden = false
        vidPlayer?.play()
        
    }
    @IBAction func stopVid(sender: AnyObject) {
        
        playButton.hidden = false
        stopButton.hidden = true
        vidPlayer?.pause()
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}