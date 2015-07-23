//
//  StopButton.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/7/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

class StopButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.blackColor()
    @IBInspectable var squareColor: UIColor = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        fillColor.set()
        CGContextFillEllipseInRect(context, rect)
        
        let squareRect = (rect.width / 2)
        
        squareColor.set()

    }

    
}
