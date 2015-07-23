
//
//  YourMainMenuViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class YourMainMenuViewController: UIViewController {

    @IBOutlet weak var backButton: OutlineButton!
    @IBOutlet weak var yourProfileMenu: UILabel!
    @IBOutlet weak var viewYourProfile: OutlineButton!
    @IBOutlet weak var searchProfiles: OutlineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }

    override func viewWillAppear(animated: Bool) {
        
        self.backButton.center.x -= self.view.bounds.width
        self.yourProfileMenu.center.y -= self.view.bounds.height
        self.viewYourProfile.center.y += self.view.bounds.height
        self.searchProfiles.center.y += self.view.bounds.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x += self.view.bounds.width
            self.yourProfileMenu.center.y += self.view.bounds.height
            self.viewYourProfile.center.y -= self.view.bounds.height
            self.searchProfiles.center.y -= self.view.bounds.height
            
        })
 
    }
    
    @IBAction func yourProfileButtonPressed(sender: AnyObject) {
        
        if RailsRequest.session().yourOwnProfile == nil {
            
            let yourProfileFlow = UIStoryboard(name: "YourProfileFlow", bundle: nil)
            
            let noProfileVC = yourProfileFlow.instantiateViewControllerWithIdentifier("noProfileVC") as! NoProfileViewController
            
            self.presentViewController(noProfileVC, animated: true, completion: nil)
            
        } else {
            
            let yourProfile = RailsRequest.session().yourOwnProfile!
        
            RailsRequest.session().getSingleProfile(yourProfile, completion: { (profileInfo) -> Void in
            
                let yourProfileFlow = UIStoryboard(name: "YourProfileFlow", bundle: nil)
                
                let yourProfileNavVC = yourProfileFlow.instantiateViewControllerWithIdentifier("yourProfileNavVC") as! UINavigationController
                
                (yourProfileNavVC.viewControllers[0] as! YourProfileViewController).loadingFromId = yourProfile
                
                self.presentViewController(yourProfileNavVC, animated: true, completion: nil)
            
            })

        }
        
    }
    
    @IBAction func searchProfilesPressed(sender: AnyObject) {
        
        let yourProfileFlow = UIStoryboard(name: "YourProfileFlow", bundle: nil)
        
        let searchProfilesNavVC = yourProfileFlow.instantiateViewControllerWithIdentifier("searchProfilesNavVC") as! UINavigationController
        
        presentViewController(searchProfilesNavVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x -= self.view.bounds.width
            self.yourProfileMenu.center.y -= self.view.bounds.height
            self.viewYourProfile.center.y += self.view.bounds.height
            self.searchProfiles.center.y += self.view.bounds.height
            
            }) { (finished) -> Void in
        
                self.navigationController?.popViewControllerAnimated(false)
                
        }

        
    }
    
}
