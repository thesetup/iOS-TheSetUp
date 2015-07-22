//
//  WelcomeViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var setupLogo: UIImageView!
    @IBOutlet weak var loginButton: OutlineButton!
    @IBOutlet weak var registerButton: OutlineButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo.center.y -= view.bounds.height

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.setupLogo.center.y += self.view.bounds.height
            
        })
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        loginButton.center.y += view.bounds.height
        registerButton.center.y += view.bounds.height
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            

            self.loginButton.center.y -= self.view.bounds.height
            self.registerButton.center.y -= self.view.bounds.height

        })
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let loginVC = storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.loginButton.center.y += self.view.bounds.height
            self.registerButton.center.y += self.view.bounds.height
            
        }) { (finished) -> Void in
            
            self.navigationController?.pushViewController(loginVC, animated: false)
            
        }
    
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        let registerVC = storyboard?.instantiateViewControllerWithIdentifier("registerVC") as! RegisterViewController
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.loginButton.center.y += self.view.bounds.height
            self.registerButton.center.y += self.view.bounds.height
            
            }) { (finished) -> Void in
                
                self.navigationController?.pushViewController(registerVC, animated: false)
                
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
