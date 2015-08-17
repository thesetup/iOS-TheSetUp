//
//  MainMenuViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/8/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var setupTitle: UIImageView!
    @IBOutlet weak var logoutButton: OutlineButton!
    @IBOutlet weak var viewYourProfile: OutlineButton!
    @IBOutlet weak var makeFriendProfiles: OutlineButton!
    @IBOutlet weak var mainMenu: UILabel!
    @IBOutlet weak var sShape: UIImageView!
    @IBOutlet weak var helpButton: OutlineButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
            self.setupTitle.alpha = 0
        
            self.logoutButton.center.x -= self.view.bounds.width
        
            self.mainMenu.center.y -= self.view.bounds.height
        
            self.viewYourProfile.center.y += self.view.bounds.height
            self.makeFriendProfiles.center.y += self.view.bounds.height
        
            self.helpButton.center.x += self.view.bounds.width
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.logoutButton.center.x += self.view.bounds.width
            
            self.mainMenu.center.y += self.view.bounds.height
                        
            self.viewYourProfile.center.y -= self.view.bounds.height
            self.makeFriendProfiles.center.y -= self.view.bounds.height
            
            self.helpButton.center.x -= self.view.bounds.width

            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yourProfileButtonPressed(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.logoutButton.center.x -= self.view.bounds.width
            
            self.mainMenu.center.y -= self.view.bounds.height
            
            self.viewYourProfile.center.y += self.view.bounds.height
            self.makeFriendProfiles.center.y += self.view.bounds.height
            
            self.helpButton.center.x += self.view.bounds.width
            
        }) { (finished) -> Void in
            
            let yourMainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("yourMainMenuVC") as! YourMainMenuViewController
            self.navigationController?.pushViewController(yourMainMenuVC, animated: false)
            
        }
        
    }

    @IBAction func friendProfileButtonPressed(sender: AnyObject) {
    
        let profileFlow = UIStoryboard(name: "ProfileFlow", bundle: nil)
        
        let profileMenuVC = profileFlow.instantiateViewControllerWithIdentifier("profileNavController") as! UINavigationController
        
        presentViewController(profileMenuVC, animated: true, completion: nil)
    
    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
    
            RailsRequest.session().userId = nil
            RailsRequest.session().token = nil
            RailsRequest.session().username = ""
            RailsRequest.session().email = ""
            RailsRequest.session().password = ""
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.logoutButton.center.x -= self.view.bounds.width
            
            self.setupTitle.alpha = 1
            
            self.mainMenu.center.y -= self.view.bounds.height
            self.sShape.center.y -= self.view.bounds.height
            
            self.viewYourProfile.center.y += self.view.bounds.height
            self.makeFriendProfiles.center.y += self.view.bounds.height
            
            self.helpButton.center.x += self.view.bounds.width
            
        }) { (finished) -> Void in
            
            self.navigationController?.popToRootViewControllerAnimated(false)
            
        }
        
    }

    @IBAction func helpButtonPressed(sender: AnyObject) {
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            
//            self.logoutButton.center.x -= self.view.bounds.width
//            
//            self.setupTitle.alpha = 1
//            
//            self.mainMenu.center.y -= self.view.bounds.height
//            self.sShape.center.y -= self.view.bounds.height
//            
//            self.viewYourProfile.center.y += self.view.bounds.height
//            self.makeFriendProfiles.center.y += self.view.bounds.height
//            
//            self.helpButton.center.x += self.view.bounds.width
//            
//            }) { (finished) -> Void in
//                
//                
//                
//        }
        
        let helpVC = self.storyboard?.instantiateViewControllerWithIdentifier("helpVC") as! HelpViewController
        
        presentViewController(helpVC, animated: true, completion: nil)
        
    }
    
}





