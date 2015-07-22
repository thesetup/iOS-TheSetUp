//
//  SearchItemCell.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/21/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class SearchItemCell: UITableViewCell {

    @IBOutlet weak var profilePicView: RadiusView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderAgeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
