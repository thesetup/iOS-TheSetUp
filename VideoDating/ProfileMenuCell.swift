//
//  ProfileMenuCell.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/6/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class ProfileMenuCell: UITableViewCell {

    
    // Load name label, applications, and picture based on JSON data.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: RadiusView?
    @IBOutlet weak var applicationsButton: CustomButton!
    @IBOutlet weak var editButton: OutlineButton!
    
    //Add Applications Count that judges whether you can view the Applications VC or not.
    
    @IBAction func applicationsButtonPressed(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
