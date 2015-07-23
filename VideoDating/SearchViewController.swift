//
//  SearchViewController.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/9/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSearch: String = ""
    
    var mySearchResults: [String:AnyObject] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        currentSearch = ""
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        currentSearch = searchText
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        view.endEditing(true)
        
        var formattedSearch: String = ""
        
        for letter in currentSearch {
            
            if letter == " " {
                
                formattedSearch += ","
                
            } else {
                
                formattedSearch += "\(letter)"
                
            }
            
        }
        
        println(formattedSearch)
        
        RailsRequest.session().searchProfiles(formattedSearch) { (searchResults) -> Void in
            
            if let noResults = searchResults["message"] as? String {
                
                let saveAlert = UIAlertController(title: "Error", message: "\(noResults)", preferredStyle: .Alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .Default) { (action: UIAlertAction!) -> Void in
                    
                }
                
                saveAlert.addAction(okayAction)
                
                self.presentViewController(saveAlert, animated: true, completion: nil)
                
            } else {
            
                self.mySearchResults = searchResults
                println("Here are my search results! \(self.mySearchResults)")
                self.tableView.reloadData()
            
            }
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
        
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if let numberOfRows = mySearchResults["questions"] as? [[String:AnyObject]] {
            
            return numberOfRows.count
            
        } else {
            
            return 0
            
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("searchItemCell", forIndexPath: indexPath) as! SearchItemCell
        
        var timeInterval: NSTimeInterval = (0.5 + (NSTimeInterval(indexPath.row) * 0.1 ))
        
        cell.center.x += self.tableView.bounds.width
        
        UIView.animateWithDuration(timeInterval, animations: { () -> Void in
            
            cell.center.x -= self.tableView.bounds.width
            
        })
        
        if let profiles = mySearchResults["profiles"] as? [[String:AnyObject]] {
            
            if let profilePicURL = (profiles[indexPath.row]["avatar_remote_url"] as? String) ?? (profiles[indexPath.row]["avatar_url"] as? String) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                    
                    if profilePicURL != "/avatars/original/missing.png" ?? "/avatars/remote/missing.png" ?? "null" {
                        
                        let avatarURL = NSURL(string: profilePicURL)
                        let data = NSData(contentsOfURL: avatarURL!)
                        let avatarImage = UIImage(data: data!)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            cell.profilePicView?.image = avatarImage
                            
                        })
                        
                    }
                    
                })
                
            }
            
        }
        
        var genderAge = ""
        
        if let questions = mySearchResults["questions"] as? [[String:AnyObject]] {
            
            if let profileName = questions[indexPath.row]["name"] as? String {
                
                cell.nameLabel.text = profileName
                
            }
            
            if let profileId = questions[indexPath.row]["id"] as? Int {
                
                cell.tag = profileId
                
            }
            
            if let gender = questions[indexPath.row]["gender"] as? String {
                
                
                genderAge += (gender + ", ")
                
            }
            
            if let birthyear = questions[indexPath.row]["birthyear"] as? Int {
                
                let age = (2015 - birthyear)
                
                genderAge += "\(age)"
                
            }
            
            cell.genderAgeLabel.text = genderAge
            
            if let city = questions[indexPath.row]["location"] as? String {
                
                cell.cityLabel.text = city
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchItemCell
        
        let searchResultVC = storyboard?.instantiateViewControllerWithIdentifier("searchResultVC") as! SearchResultViewController
        
        searchResultVC.profileToLoad = cell.tag
        
        self.navigationController?.pushViewController(searchResultVC, animated: true)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
}
