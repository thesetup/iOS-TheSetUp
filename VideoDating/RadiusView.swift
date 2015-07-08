//
//  RadiusView.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/2/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

@IBDesignable class RadiusView: UIImageView {
    
    @IBInspectable var imageViewRadius: CGFloat = 15 {
        
        didSet {
            
            self.layer.cornerRadius = imageViewRadius
            self.layer.masksToBounds = true
            
        }
        
    }
    
}
