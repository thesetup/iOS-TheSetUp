//
//  EditProfileTableViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/8/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

    //Section 1 Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var yearOfBirthTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBOutlet weak var orientationSegment: UISegmentedControl!
    
    var orientation: String = "Straight"
    var gender: String = "Male"
    
    // Optional variable for info. Set this when instantiating this VC.
    var loadingFromId: Int?
    
    var profilesToLoad: [[String:AnyObject]] = []
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            self.view.setNeedsUpdateConstraints()
            self.view.setNeedsLayout()
            
            if let kbSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size{
                
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
        }
        
        if loadingFromId != nil {
            
//            RecordedVideo.session().loadRailsInfoToSingleton(loadingFromId!)
//            
//            profilePictureView.image = RecordedVideo.session().profilePicture
//            addProfilePicture.titleLabel!.hidden = true
//            
//            nameTextField.text = RecordedVideo.session().name
//            emailTextField.text = RecordedVideo.session().email
//            passwordTextField.text = RecordedVideo.session().password
//            yearOfBirthTextField.text = RecordedVideo.session().birthyear
//            locationTextField.text = RecordedVideo.session().location
//            genderSegment.selectedSegmentIndex = RecordedVideo.session().gender
//            orientationSegment.selectedSegmentIndex = RecordedVideo.session().orientation
//            occupationTextField.text = RecordedVideo.session().occupation
            
        }
    }
    
    @IBAction func genderSwitchPressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0: gender = "Male";
            
        case 1: gender = "Female";
            
        default: break
            
        }
        
    }
    
    @IBAction func orientationSwitchPressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0: orientation = "Straight";
            
        case 1: orientation = "Gay";
            
        default: break
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        yearOfBirthTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        occupationTextField.resignFirstResponder()
        
    }
    
    func convertURLtoViewImage(stringToConvert: String, viewToAddImage: RadiusView) {
        
        if let newURL = NSURL(string: stringToConvert) {
            
            let newUIImage = UIImage(data: NSData(contentsOfURL: newURL)!)
            viewToAddImage.image = newUIImage
            
        }
        
    }
    
    @IBAction func addProfilePicture(sender: AnyObject) {
        
        RailsRequest.session().currentCreatingId = nil
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let cameraNavVC = videoStoryboard.instantiateViewControllerWithIdentifier("cameraNavVC") as! UINavigationController
        
        presentViewController(cameraNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        RecordedVideo.session().resetSingleton()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        if nameTextField.text.isEmpty == false && emailTextField.text.isEmpty == false && passwordTextField.text.isEmpty == false && yearOfBirthTextField.text.isEmpty == false && locationTextField.text.isEmpty == false && occupationTextField.text.isEmpty == false {
        
            // Make RailsRequest to save data.
            if loadingFromId != nil {
                
                // Patch request to update profile will go here.
                
            } else {
                
                RecordedVideo.session().name = nameTextField.text
                RecordedVideo.session().email = emailTextField.text
                RecordedVideo.session().password = passwordTextField.text
                RecordedVideo.session().birthyear = yearOfBirthTextField.text
                RecordedVideo.session().location = locationTextField.text
                RecordedVideo.session().gender = gender
                RecordedVideo.session().orientation = orientation
                RecordedVideo.session().occupation = occupationTextField.text
                
                RailsRequest.session().createProfile({ () -> Void in
                    // The completion of createProfiles gets the ID for the profile I'm current making and makes it the destination for the profile picture.
                    
                    let launchVC = self.storyboard?.instantiateViewControllerWithIdentifier("launchVC") as! LaunchViewController
                    
                    self.navigationController?.pushViewController(launchVC, animated: true)
                    
                })

            }
        
        } else {
            
            let submitAlert = UIAlertController(title: "Error", message: "Please complete all text fields.", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction!) -> Void in
                                
            }
            
            submitAlert.addAction(confirmAction)
            
            presentViewController(submitAlert, animated: true, completion: nil)
            
        }
    }
    
    func beginVideoRecording(videoCategory: VideoTypes, videoLength: Int) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoCamNavVC = videoStoryboard.instantiateViewControllerWithIdentifier("videoCamNavVC") as! UINavigationController
        
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoDuration = videoLength
        (videoCamNavVC.viewControllers[0] as! VideoCamViewController).videoType = videoCategory
        
        presentViewController(videoCamNavVC, animated: true, completion: nil)
        
    }
    
    func launchVideoPlayer(videoToPlay: NSURL) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = videoStoryboard.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = videoToPlay
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
    }
    
}
