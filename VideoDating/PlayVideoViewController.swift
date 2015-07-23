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
    @IBOutlet weak var backButton: OutlineButton!
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        backButton.center.x -= view.bounds.height
        playButton.center.y += view.bounds.height
        stopButton.center.y += view.bounds.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x += self.view.bounds.height
            self.playButton.center.y -= self.view.bounds.height
            self.stopButton.center.y -= self.view.bounds.height
            
        })
        
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