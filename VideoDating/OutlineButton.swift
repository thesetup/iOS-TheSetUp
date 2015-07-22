//
//  OutlineButton.swift
//  VideoDating
//
//  Created by Kyle Brooks Robinson on 7/12/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit

@IBDesignable class OutlineButton: UIButton {
        
        @IBInspectable var cornerRadius: CGFloat = 10
        @IBInspectable var buttonColor: UIColor = UIColor.clearColor()
        @IBInspectable var strokeColor: UIColor = UIColor.blueColor()
        @IBInspectable var strokeWidth: CGFloat = 1
        
        override func drawRect(rect: CGRect) {
            
            var context = UIGraphicsGetCurrentContext()
            
            let insetRect = CGRectInset(rect, strokeWidth / 2, strokeWidth / 2)
            
            let path = UIBezierPath(roundedRect: insetRect, cornerRadius: cornerRadius)
            
            buttonColor.set()
            
            CGContextAddPath(context, path.CGPath)
            CGContextFillPath(context)
            
            strokeColor.set()
            
            CGContextSetLineWidth(context, strokeWidth)
            CGContextAddPath(context, path.CGPath)
            CGContextStrokePath(context)
            
        }
        
}