//
//  RegisterViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sShape: UIImageView!
    @IBOutlet weak var setupLogo: UIImageView!
    @IBOutlet weak var backButton: OutlineButton!
    @IBOutlet weak var registerButton: OutlineButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    var registrationInfo: [String:String] = [:]
    
    var areFieldsCompleted: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
        
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
    
    override func viewWillAppear(animated: Bool) {
        
        self.sShape.alpha = 0
        
        self.backButton.center.x -= self.view.bounds.width
        self.registerButton.center.y += self.view.bounds.height
        
        self.usernameTextField.center.x -= self.view.bounds.width
        self.emailTextField.center.x -= self.view.bounds.width
        self.passwordTextField.center.x -= self.view.bounds.width
        self.confirmPasswordTextField.center.x -= self.view.bounds.width

        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x += self.view.bounds.width
            self.registerButton.center.y -= self.view.bounds.height
            
            self.usernameTextField.center.x += self.view.bounds.width
            self.emailTextField.center.x += self.view.bounds.width
            self.passwordTextField.center.x += self.view.bounds.width
            self.confirmPasswordTextField.center.x += self.view.bounds.width
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //finisButtonPressed
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        if emailTextField.text.isEmpty == false && passwordTextField.text.isEmpty == false && confirmPasswordTextField.text.isEmpty == false {
            
            if passwordTextField.text == confirmPasswordTextField.text {
                
                errorLabel.text = ""
                
                RailsRequest.session().username = usernameTextField.text
                RailsRequest.session().email = emailTextField.text
                RailsRequest.session().password = passwordTextField.text
                RailsRequest.session().registerWithCompletion(errorLabel, completion: { () -> Void in
                    
                    let mainMenuVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainMenuVC") as! MainMenuViewController
                    
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        
                        self.sShape.alpha = 1
                        
                        self.setupLogo.center.y -= self.view.bounds.height
                        self.backButton.center.x += self.view.bounds.width
                        self.registerButton.center.y += self.view.bounds.height
                        
                        self.usernameTextField.center.x -= self.view.bounds.width
                        self.emailTextField.center.x -= self.view.bounds.width
                        self.passwordTextField.center.x -= self.view.bounds.width
                        self.confirmPasswordTextField.center.x -= self.view.bounds.width
                        
                        //                    self.setupLogo.center.y -= self.view.bounds.height
                        
                        }, completion: { (finished) -> Void in
                            
                            self.navigationController?.pushViewController(mainMenuVC, animated: false)
                            
                    })
                    
                })
                
            } else {
                
                errorLabel.text = "Error: Passwords don't match."
                
            }
            
        } else {
            
            errorLabel.text = "Please ensure that all fields have been completed."
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.backButton.center.x -= self.view.bounds.width
            self.registerButton.center.y += self.view.bounds.height
            
            self.usernameTextField.center.x -= self.view.bounds.width
            self.emailTextField.center.x -= self.view.bounds.width
            self.passwordTextField.center.x -= self.view.bounds.width
            self.confirmPasswordTextField.center.x -= self.view.bounds.width
            
            
            }) { (finished) -> Void in
                
                self.navigationController?.popViewControllerAnimated(false)
                
                
            }
        
        
        
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