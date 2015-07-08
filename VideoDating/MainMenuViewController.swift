//
//  MainMenuViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/8/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yourProfileButtonPressed(sender: AnyObject) {
        
        
        
    }

    @IBAction func friendProfileButtonPressed(sender: AnyObject) {
    
        let profileFlow = UIStoryboard(name: "ProfileFlow", bundle: nil)
        
        let profileMenuVC = profileFlow.instantiateViewControllerWithIdentifier("profileNavController") as! UINavigationController
        
        presentViewController(profileMenuVC, animated: true, completion: nil)
    
    }

}