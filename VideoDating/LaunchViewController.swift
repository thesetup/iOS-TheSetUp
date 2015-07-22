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
    
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func avatarButtonPressed(sender: AnyObject) {
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let cameraChooseVC = videoStoryboard.instantiateViewControllerWithIdentifier("cameraChooseVC") as! CameraChooseViewController
        
        cameraChooseVC.loadingFromId = RailsRequest.session().currentCreatingId!
        
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
