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
    @IBOutlet weak var startButton: PlayButton!
    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var flipButton: CustomButton!
    @IBOutlet weak var backButton: CustomButton!
    
    var videoPick = UIImagePickerController()
    
    // Timer info.  Set videoDuration from previous VC.
    @IBOutlet weak var timerLabel: UILabel!
    var timer: NSTimer?
    var videoDuration: Int = 30
    var countdown: Int = 30
    
    var saveVideoVC: SaveVideoViewController?
    var thumbnail: UIImage?
    
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    var thumbnailImage: UIImage?
    var videoString: String?
    
    var videoType: VideoTypes?
    
    var replyViewController: MessageReplyViewController?
    
    override func viewWillAppear(animated: Bool) {
        
        timerLabel.hidden = false
        timerLabel.text = "\(videoDuration)"
        
        startButton.hidden = false
        stopButton.hidden = true
        flipButton.hidden = false
        
        timerLabel.center.x += view.bounds.width
        backButton.center.y -= view.bounds.height
        startButton.center.y += view.bounds.height
        stopButton.center.y += view.bounds.height
        flipButton.center.y += view.bounds.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.timerLabel.center.x -= self.view.bounds.width
            self.backButton.center.y += self.view.bounds.height
            self.startButton.center.y -= self.view.bounds.height
            self.stopButton.center.y -= self.view.bounds.height
            self.flipButton.center.y -= self.view.bounds.height
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.text = "\(videoDuration)"
        
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
            println("here's my video url! \(videoURL)")
            
            createThumbnail()
            imageResize()
            
            S3Request.session().videoURL = vidURL.path!
            
            saveVideoVC = storyboard?.instantiateViewControllerWithIdentifier("saveVideoVC") as? SaveVideoViewController
            
            saveVideoVC!.videoURL = vidURL
            saveVideoVC!.thumbnailImage = thumbnailImage
            saveVideoVC!.videoStillImage = videoStillImage
            saveVideoVC!.videoType = videoType
            saveVideoVC!.videoString = videoString
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.timerLabel.center.x += self.view.bounds.width
                self.backButton.center.y -= self.view.bounds.height
                self.startButton.center.y += self.view.bounds.height
                self.stopButton.center.y += self.view.bounds.height
                self.flipButton.center.y += self.view.bounds.height
                
            })
            
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
        
        var newSize = CGSize(width: 480,height: 480)
        var scaleImageRect = CGRectMake(0,0, newSize.width, newSize.height)
        
        let ratio: CGFloat = newSize.width / videoStillImage!.size.width
        let newHeight = ratio * videoStillImage!.size.height
        let newY = (newSize.height - newHeight) / 2
        
        scaleImageRect = CGRectMake(0, newY, newSize.width, newHeight)
        
        UIGraphicsBeginImageContext(newSize)
        
        videoStillImage!.drawInRect(scaleImageRect)
        thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    func updateSecondsLeft() {
        
        countdown--
        
        if countdown == 0 {
            
            stopRecording()
            
        } else {
            
            timerLabel.text = String(countdown)
            
        }
        
    }
    
    func stopRecording() {
        
        timer?.invalidate()
        videoPick.stopVideoCapture()
        
        var countDown = videoDuration
        
        timerLabel.text = "\(videoDuration)"
        stopButton.hidden = true
        
    }
    
    @IBAction func recordButtonPressed(sender: AnyObject) {
        
        startButton.hidden = true
        stopButton.hidden = false
        flipButton.hidden = true
        
        videoPick.startVideoCapture()
        
        countdown = videoDuration
        
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //Not sure what this stuff's for.
//        replyViewController?.videoURL = videoURL
//        replyViewController?.videoStillImage = videoStillImage
//        
//        imagePickerControllerDidCancel(videoPick)
//        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
}






