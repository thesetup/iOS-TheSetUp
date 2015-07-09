//
//  EditProfileTableViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/8/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    //Section 1 Outlets
    
    @IBOutlet weak var profilePictureView: RadiusView!
    @IBOutlet weak var addProfilePicture: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var yearOfBirthTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var orientationTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    
    // Main Video
    @IBOutlet weak var mainVideo: UIImageView!
    
    // Looking For Video
    @IBOutlet weak var lookingForVideo: RadiusView!
    
    // Collection Views
    @IBOutlet weak var hobbyCollectionView: UICollectionView!
    @IBOutlet weak var tastesCollectionView: UICollectionView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hobbyCollectionView.tag = 0
        tastesCollectionView.tag = 1

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

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell: UICollectionViewCell
        
        if collectionView.tag == 0 {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("hobbiesCell", forIndexPath: indexPath) as! HobbiesCollectionViewCell
            
//            launchVideoPlayer(<#videoToPlay: String#>)
            
        } else {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("tastesCell", forIndexPath: indexPath) as! TastesCollectionViewCell
            
//            launchVideoPlayer(<#videoToPlay: String#>)

            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell
        
        if collectionView.tag == 0 {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("hobbiesCell", forIndexPath: indexPath) as! HobbiesCollectionViewCell

            
        } else {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("tastesCell", forIndexPath: indexPath) as! TastesCollectionViewCell

        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    @IBAction func addHobbiesButtonPressed(sender: AnyObject) {
    
    
    }
    
    @IBAction func addTastesButtonPressed(sender: AnyObject) {
    
    
    }
    
    func launchVideoPlayer(videoToPlay: String) {
        
        let stringToURL = NSURL(string: videoToPlay)
        
        let videoStoryboard = UIStoryboard(name: "TakeVideoFlow", bundle: nil)
        
        let videoPlayerVC = videoStoryboard.instantiateViewControllerWithIdentifier("playVideoVC") as! PlayVideoViewController
        
        videoPlayerVC.videoURL = stringToURL
        
        presentViewController(videoPlayerVC, animated: true, completion: nil)
        
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
