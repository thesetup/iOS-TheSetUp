//
//  YourMessagesDetailViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class YourMessagesDetailViewController: UITableViewController {
    
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
    
    

    @IBAction func replyButtonPressed(sender: AnyObject) {
        
        let messageReplyVC = storyboard?.instantiateViewControllerWithIdentifier("messageReplyVC") as! MessageReplyViewController
        
        self.navigationController?.pushViewController(messageReplyVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        stopButton.hidden = true
        
        if videoData != nil {
            
            vidPlayer = MPMoviePlayerController(contentURL: videoURL)
            vidPlayer?.controlStyle = MPMovieControlStyle.None
            vidPlayer?.view.frame = self.view.frame
            vidPlayer?.scalingMode = MPMovieScalingMode.AspectFit
            videoView.addSubview(vidPlayer!.view)
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
