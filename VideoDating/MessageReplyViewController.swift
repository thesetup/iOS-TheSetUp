//
//  MessageReplyViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class MessageReplyViewController: UITableViewController {

    @IBOutlet weak var videoThumbnailView: UIImageView!
    @IBOutlet weak var addVideoButton: CustomButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var videoURL: NSURL?
    var videoStillImage: UIImage?
    
    var isThereAVideo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func addVideoButtonPressed(sender: AnyObject) {
        
        let takeVideoFlow = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoCamVC = takeVideoFlow.instantiateViewControllerWithIdentifier("takeVideoVC") as! VideoCamViewController
        
        videoCamVC.replyViewController = self
        
        presentViewController(videoCamVC, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        
        let saveAlert = UIAlertController(title: "Save Video", message: "Do you want to save this video?", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (action: UIAlertAction!) -> Void in
            
        self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
            saveAlert.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        saveAlert.addAction(confirmAction)
        saveAlert.addAction(cancelAction)
        
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
