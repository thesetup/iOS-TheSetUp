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
    
    var userInfoArray: [[String:AnyObject]] = []
    var avatarInfo: [String] = []
    var mySearchResults: [[String:AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    // MARK: - Table view data source
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        RailsRequest.session().searchProfiles(searchBar.text, completion: { (searchResults) -> Void in
            
            self.mySearchResults = searchResults
            
            self.tableView.reloadData()
            
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mySearchResults.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("searchItemCell", forIndexPath: indexPath) as! SearchItemCell
        
        var ageText = ""
        var genderText = ""
        
        if let searchResultItem = mySearchResults[indexPath.row] as [String:AnyObject]? {
            
            if let profileId = searchResultItem["id"] as? Int {
                
                cell.tag = profileId
                
            }
            
            if let avatarURL = searchResultItem["avatar_url"] as? String {
                
                let newURL: NSURL = NSURL(string: avatarURL)!
                let data: NSData = NSData(contentsOfURL: newURL)!
                let avatarImage = UIImage(data: data)
                
                cell.profilePicView.image = avatarImage
                
            }
            
            if let name = searchResultItem["name"] as? String {
                
                cell.nameLabel.text = name
                
            }
            
            if let location = searchResultItem["location"] as? String {
                
                cell.cityLabel.text = location
                
            }
            
            if let birthyear = searchResultItem["age"] as? Int {
                
                ageText = "\(2015 - birthyear)"
                
            }
            
            if let gender = searchResultItem["gender"] as? String {
                
                genderText = gender
                
            }
            
            cell.genderAgeLabel.text = "\(genderText), \(ageText)"
            
        }

    return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchItemCell
        
        let searchResultVC = storyboard?.instantiateViewControllerWithIdentifier("searchResultVC") as! SearchResultViewController
        
        searchResultVC.profileToLoad = cell.tag
        
        self.navigationController?.pushViewController(searchResultVC, animated: true)
        
    }
    
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
