//
//  VideoCell.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var snapshotView: RadiusView!
    @IBOutlet weak var videoTitle: UILabel!

    @IBOutlet weak var statusView: UILabel!
    
    @IBAction func editVideo(sender: AnyObject) {
    
    
    }
    
    @IBAction func detailsPressed(sender: AnyObject) {
    
    
    
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
