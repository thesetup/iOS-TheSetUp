//
//  ApplicationDetailViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/6/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class ApplicationDetailViewController: UITableViewController {

    // Profile info section outlets and buttons
    @IBOutlet weak var profilePicImageView: RadiusView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    // Video section outlets and buttons
    
    @IBOutlet weak var videoView: RadiusView!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var stopButton: CustomButton!
    
    var vidPlayer: MPMoviePlayerController?
    var videoData: NSData?
    var videoURL: NSURL?
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        
        playButton.hidden = true
        stopButton.hidden = false
        vidPlayer?.play()
        
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        
        playButton.hidden = false
        stopButton.hidden = true
        vidPlayer?.stop()
        
    }

    
    
    //Evaluation section outlets and buttons
    
    var canSubmit: Bool = false
    
    @IBOutlet weak var redButton: CustomButton!
    @IBOutlet weak var blueButton: CustomButton!
    @IBOutlet weak var greenButton: CustomButton!
    @IBOutlet weak var orangeButton: CustomButton!
    
    
    
    @IBAction func buttonSelected(sender: CustomButton) {
        
        var evaluationButtons = [
            redButton, blueButton, greenButton, orangeButton
        ]
        
        for button in evaluationButtons {
            
            if button == sender as CustomButton {
                
                sender.selectedButton = true
                canSubmit = true
                
            } else {
                
                sender.selectedButton = false
                
            }
            
        }
        
    }
    
    
    
    // Contact section outlets and buttons
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        if canSubmit == false {
            
            errorLabel.text = "Please select an approval level."
            
        } else {
            
            errorLabel.text = ""
            
            // Show Alert asking for confirmation here.
            
            
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PENDING:  Set text to info from Rails Request
        
        aboutMeLabel.text = ""
        errorLabel.text = ""
        stopButton.hidden = true
        
        if videoData != nil {
            
            println("This stuff should be running.")
            
            vidPlayer = MPMoviePlayerController(contentURL: videoURL)
            vidPlayer?.controlStyle = MPMovieControlStyle.None
            vidPlayer?.view.frame = self.view.frame
            vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
            videoView.addSubview(vidPlayer!.view)
            
        }
        
        //PENDING: Set Name, Age, Location, Job, and About Me labels to info from Rails request.

        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
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
