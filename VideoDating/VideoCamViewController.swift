//
//  VideoCamViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import MobileCoreServices

class VideoCamViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Outlets for the camera elements.
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var flipButton: CustomButton!
    @IBOutlet weak var backButton: CustomButton!
    
    var videoPick = UIImagePickerController()
    
    // Timer info.  Set videoDuration from previous VC.
    @IBOutlet weak var timerLabel: UILabel!
    var timer: NSTimer?
    var videoDuration: Int = 30
    var countDown: Int = 30
    
    
    var saveVideoVC: SaveVideoViewController?
    var thumbnail: UIImage?
    
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.hidden = true
        
        videoPick.sourceType = .Camera
        videoPick.cameraDevice = .Rear
        videoPick.mediaTypes = [kUTTypeMovie]
        videoPick.cameraCaptureMode = .Video
        videoPick.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        videoPick.delegate = self
        videoPick.showsCameraControls = false
        videoPick.view.frame = videoView.frame
        videoView.addSubview(videoPick.view)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let vidURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            
            videoURL = vidURL
            
            createThumbnail()
            imageResize()
            
            S3Request.session().videoURL = vidURL.path!
            
            saveVideoVC = storyboard?.instantiateViewControllerWithIdentifier("saveVideoVC") as? SaveVideoViewController
            
            saveVideoVC!.videoURL = vidURL
            saveVideoVC!.videoStillImage = videoStillImage
            
            self.navigationController?.pushViewController(saveVideoVC!, animated: true)
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func createThumbnail() {
        
        let asset = AVURLAsset(URL: videoURL, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let frameTime = CMTimeMakeWithSeconds(0.0, 600)
        let actualTimePointer = UnsafeMutablePointer<CMTime>()
        let stupendousError = NSErrorPointer()
        
        videoStillImage = UIImage(CGImage: generator.copyCGImageAtTime(frameTime, actualTime: actualTimePointer, error: stupendousError))
        
    }
    
    func imageResize() {
        
        var newSize = CGSize(width: 480,height: 640)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        videoStillImage!.drawInRect(rect)
        videoStillImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
    
    func updateSecondsLeft() {
        
        countDown--
        
        if countDown == 0 {
            
            stopRecording()
            
        } else {
            
            timerLabel.text = String(countDown)
            
        }
        
    }
    
    func stopRecording() {
        
        timer?.invalidate()
        videoPick.stopVideoCapture()
        
        countDown = videoDuration
        
        timerLabel.text = "\(videoDuration)"
        stopButton.hidden = true
        startButton.hidden = false
        flipButton.hidden = false
        
    }
    
    @IBAction func recordButtonPressed(sender: AnyObject) {
        
        startButton.hidden = true
        stopButton.hidden = false
        flipButton.hidden = true
        
        videoPick.startVideoCapture()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateSecondsLeft"), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        
        stopRecording()
        
    }
    
    @IBAction func flipButtonPressed(sender: AnyObject) {
        
        if videoPick.cameraDevice == .Front {
            
            videoPick.cameraDevice = .Rear
            
        } else {
            
            videoPick.cameraDevice = .Front
            
        }
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        imagePickerControllerDidCancel(videoPick)
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
}






