//
//  LoginViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sShape: UIImageView!
    @IBOutlet weak var setupLogo: UIImageView!
    @IBOutlet weak var backButton: OutlineButton!
    @IBOutlet weak var loginButton: OutlineButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if emailField.text.isEmpty == false && passwordField.text.isEmpty == false {
            
            errorLabel.text = ""
            
            RailsRequest.session().email = emailField.text
            RailsRequest.session().password = passwordField.text
            
            println("Here's some more info for my Rails Request.")
            println("User ID: \(RailsRequest.session().userId)")
            println(RailsRequest.session().email)
            println(RailsRequest.session().password)
            println("Profile ID: \(RailsRequest.session().userId)")
            
            RailsRequest.session().login(errorLabel, completion: { () -> Void in
                
                println("Login storyboard transition should perform now.")
                
                let mainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuVC") as! MainMenuViewController
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.sShape.alpha = 1
                    self.setupLogo.center.y -= self.view.bounds.height
                    self.backButton.center.x -= self.view.bounds.width
                    self.loginButton.center.y += self.view.bounds.height
                    
                    self.emailField.center.x -= self.view.bounds.width
                    self.passwordField.center.x -= self.view.bounds.width
                    
//                    self.setupLogo.center.y -= self.view.bounds.height
                    
                }, completion: { (completionInfo) -> Void in
                    
                    self.navigationController?.pushViewController(mainMenuVC, animated: false)

                })
                
            })
            
        } else {
            
            errorLabel.text = "Please ensure that all fields have been completed."
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            self.view.setNeedsUpdateConstraints()
            self.view.setNeedsLayout()
            
            if let kbSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size{
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.bottomConstraint.constant = 20 + kbSize.height
                    
                })
                
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.bottomConstraint.constant = 20
                
            })
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.sShape.alpha = 0

        self.backButton.center.x -= self.view.bounds.width
        self.loginButton.center.y += self.view.bounds.height
        
        self.emailField.center.x -= self.view.bounds.width
        self.passwordField.center.x -= self.view.bounds.width
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x += self.view.bounds.width
            self.loginButton.center.y -= self.view.bounds.height
            
            self.emailField.center.x += self.view.bounds.width
            self.passwordField.center.x += self.view.bounds.width

        })
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x -= self.view.bounds.width
            self.loginButton.center.y += self.view.bounds.height
            
            self.emailField.center.x -= self.view.bounds.width
            self.passwordField.center.x -= self.view.bounds.width
            
            
        }) { (finished) -> Void in
            
            self.navigationController?.popViewControllerAnimated(false)

            
        }
        
    }
    
}
