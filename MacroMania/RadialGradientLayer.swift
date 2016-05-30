//
//  RadialGradientLayer.swift
//  MacroMania
//
//  Created by Ken Yu on 5/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

import UIKit

class RadialGradientLayer: CALayer {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawInContext(ctx: CGContext) {
        self.bounds = bounds
        self.position = position
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let components : [CGFloat] = [
            55/255.0,   10/255.0,   120/255.0,   0.0,
            55/255.0,   10/255.0,   120/255.0,   0.2,
            55/255.0,   10/255.0,   120/255.0,   0.0
        ]
        
        let locations : [CGFloat] = [0.5, 0.75, 1.0]
        
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, components.count/4)
        
        let centerPoint = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let gradientRadius = bounds.width/2
        
        let context = UIGraphicsGetCurrentContext()
//        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
//        CGContextDrawRadialGradient(context, gradient, centerPoint, 0, centerPoint, gradientRadius, 0)
    }
    
        
}