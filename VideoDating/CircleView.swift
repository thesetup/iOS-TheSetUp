//
//  CircleView.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/6/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {

    @IBInspectable var circleColor: UIColor = UIColor.blackColor() {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        circleColor.set()
        CGContextFillEllipseInRect(context, rect)
        
    }

}
