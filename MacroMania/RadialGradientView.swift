//
//  RadialGradientView.swift
//  MacroMania
//
//  Created by Ken Yu on 5/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public class RadialGradientView: UIView {
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let locations: [CGFloat] = [0.0, 0.5, 1.0]
        
        let colors = [Styles.Colors.AppPurple.colorWithAlphaComponent(0.0).CGColor,
                      Styles.Colors.AppPurple.colorWithAlphaComponent(0.8).CGColor,
                      Styles.Colors.AppPurple.colorWithAlphaComponent(0.0).CGColor]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradientCreateWithColors(colorspace,
                                                  colors, locations)
        
        var startPoint =  CGPoint()
        var endPoint  = CGPoint()
        
        startPoint.x = bounds.width/2
        startPoint.y = bounds.height/2
        endPoint.x = bounds.width/2
        endPoint.y = bounds.height/2
        let outerRadius: CGFloat = bounds.width/2
        let innerRadius: CGFloat = bounds.width/3
        
        CGContextDrawRadialGradient(context, gradient, startPoint,
                                    innerRadius, endPoint, outerRadius, CGGradientDrawingOptions(rawValue: 0))
    }
}