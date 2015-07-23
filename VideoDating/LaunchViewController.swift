//
//  LaunchViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/19/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var avatarButton: CustomButton!
    @IBOutlet weak var videosButton: CustomButton!
    
    var userId = RailsRequest.session().currentCreatingId!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func avatarButtonPressed(sender: AnyObject) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let cameraChooseVC = videoStoryboard.instantiateViewControllerWithIdentifier("cameraChooseVC") as! CameraChooseViewController
                
        self.navigationController?.pushViewController(cameraChooseVC, animated: true)
        
    }

    @IBAction func videosButtonPressed(sender: AnyObject) {
        
        let editVideosVC = self.storyboard?.instantiateViewControllerWithIdentifier("editVideosVC") as! EditVideosViewController
        
        editVideosVC.loadingFromId = RailsRequest.session().currentCreatingId!
        
        self.navigationController?.pushViewController(editVideosVC, animated: true)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}
