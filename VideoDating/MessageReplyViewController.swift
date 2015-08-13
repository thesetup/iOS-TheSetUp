//
//  MessageReplyViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import Parse
import Bolts

class MessageReplyViewController: UITableViewController {

    @IBOutlet weak var replyTo: UILabel!
    @IBOutlet weak var videoThumbnailView: UIImageView!
    @IBOutlet weak var addVideoButton: CustomButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var textField: UITextField!
    
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    
    var isThereAParseProfile: Bool = false
    var isThereAVideo: Bool = false
    var sendingToId: Int!
    var sendingToName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        submitButton.hidden = true
//        
//        var query = PFQuery(className:"Profile\(sendingToId)")
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            
//            if error == nil {
//                
//                self.isThereAParseProfile = true
//                
//            } else {
//                
//                println("There is no existing Parse class for this user.")
//                
//            }
//            
//            self.submitButton.hidden = false
//        
//        }
        
        replyTo.text = "Reply to \(sendingToName)"
        
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

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if RecordedVideo.session().messageVideoURL != nil {
            
            videoThumbnailView.image = RecordedVideo.session().messageVideoThumbnail
            
        }
        
    }
    
    @IBAction func addVideoButtonPressed(sender: AnyObject) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoCamNavVC = videoStoryboard.instantiateViewControllerWithIdentifier("videoCamNavVC") as! UINavigationController
        
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoDuration = 30
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoType = VideoTypes.Message
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoString = "message"
        
        presentViewController(videoCamNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        
        let saveAlert = UIAlertController(title: "Save Video", message: "Do you want to save this video?", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (action: UIAlertAction!) -> Void in
            
            let thumbnail = RecordedVideo.session().messageVideoThumbnail!
            let thumbnailEndpoint = RecordedVideo.session().messageVideoThumbnailLink!
            let videoData = RecordedVideo.session().messageVideoURL!
            let videoEndpoint = RecordedVideo.session().messageVideoLink!
            
            let sentBy = RailsRequest.session().yourOwnProfile
            let textMessage = self.textField.text
            let parseVideoLink = S3_URL + videoEndpoint
            let parseThumbLink = S3_URL + thumbnailEndpoint
            
            S3Request.session().saveVideoToS3(thumbnail, thumbnailEndpoint: thumbnailEndpoint, videoData: videoData, videoEndpoint: videoEndpoint)
            
            var newUser = PFObject(className: "Profile\(self.sendingToId)")
            
            newUser["sentBy"] = sentBy
            newUser["textMessage"] = textMessage
            newUser["videoThumbnail"] = parseVideoLink
            newUser["videoURL"] = parseThumbLink
            
            newUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if success {
                    
                    println("Yay! Your data saved.")
                    
                } else {
                    
                    println("Something went horribly wrong.")
                    
                }
                
            })
            
//            if self.isThereAParseProfile == true {
//                
//                //This adds information to an existing class.
//                
//            } else {
//                
//                //This creates a new class.
//                // New class should have these columns: videoURL, textMessage, sentBy
//                
//                
//                
//            }
//            
        RecordedVideo.session().resetSingleton()
            
        self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
            saveAlert.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        saveAlert.addAction(confirmAction)
        saveAlert.addAction(cancelAction)
        
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
        textField.resignFirstResponder()
        
    }

}
