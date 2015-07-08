//
//  LoginViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if emailField.text.isEmpty == false && passwordField.text.isEmpty == false {
            
            errorLabel.text = ""
            
            RailsRequest.session().email = emailField.text
            RailsRequest.session().password = passwordField.text
            
            RailsRequest.session().login({ () -> Void in
                
                println("Login storyboard transition should perform now.")
                
                let mainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuVC") as! MainMenuViewController
                
                self.navigationController?.pushViewController(mainMenuVC, animated: true)
                
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
        
        //        self.emailField.delegate = self
        
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
        
        // Do any additional setup after loading the view.
    }
    
}
