//
//  RingGradientView.swift
//  MacroMania
//
//  Created by Ken Yu on 5/9/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

import UIKit

class RingGradientLayer: CALayer {
    
    override init() {
        super.init()
    }
    
    convenience init(bounds:CGRect,position:CGPoint,fromColor:UIColor,toColor:UIColor,linewidth:CGFloat,toValue:CGFloat) {
        self.init()
        self.bounds = bounds
        self.position = position
        let colors : [UIColor] = self.graintFromColor(fromColor, toColor:toColor, count:4)
        for i in 0..<colors.count-1 {
            let graint = CAGradientLayer()
            graint.bounds = CGRectMake(0,0,CGRectGetWidth(bounds)/2,CGRectGetHeight(bounds)/2)
            let valuePoint = self.positionArrayWithMainBounds(self.bounds)[i]
            graint.position = valuePoint
            print("iesimo graint position: \(graint.position)")
            let fromColor = colors[i]
            let toColor = colors[i+1]
            let colors : [CGColorRef] = [fromColor.CGColor,toColor.CGColor]
            let stopOne: CGFloat = 0.0
            let stopTwo: CGFloat = 1.0
            let locations : [CGFloat] = [stopOne,stopTwo]
            graint.colors = colors
            graint.locations = locations
            graint.startPoint = self.startPoints()[i]
            graint.endPoint = self.endPoints()[i]
            self.addSublayer(graint)
            //Set mask
            let shapelayer = CAShapeLayer()
            let rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * linewidth, CGRectGetHeight(self.bounds) - 2 * linewidth)
            shapelayer.bounds = rect
            shapelayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)
            shapelayer.strokeColor = UIColor.blueColor().CGColor
            shapelayer.fillColor = UIColor.clearColor().CGColor
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: CGRectGetWidth(rect)/2).CGPath
            shapelayer.lineWidth = linewidth
            shapelayer.lineCap = kCALineCapButt
            shapelayer.strokeStart = 0.010
            let finalValue = (toValue * 0.999)
            shapelayer.strokeEnd = finalValue//0.99;
            self.mask = shapelayer
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layerWithWithBounds(bounds:CGRect, position:CGPoint, fromColor:UIColor, toColor:UIColor, linewidth : CGFloat,toValue:CGFloat) -> RingGradientLayer {
        let layer = RingGradientLayer(bounds: bounds,position: position,fromColor:fromColor, toColor: toColor,linewidth: linewidth,toValue:toValue )
        return layer
    }
    
    func graintFromColor(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        var result : [UIColor]! = [UIColor]()
        
        for i in 0...count {
            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
            print(oneColor)
            
        }
        return result
    }
    
    func positionArrayWithMainBounds(bounds:CGRect) -> [CGPoint]{
        let first = CGPointMake((CGRectGetWidth(bounds)/4)*3, (CGRectGetHeight(bounds)/4)*1)
        let second = CGPointMake((CGRectGetWidth(bounds)/4)*3, (CGRectGetHeight(bounds)/4)*3)
        let third = CGPointMake((CGRectGetWidth(bounds)/4)*1, (CGRectGetHeight(bounds)/4)*3)
        let fourth = CGPointMake((CGRectGetWidth(bounds)/4)*1, (CGRectGetHeight(bounds)/4)*1)
        print([first,second,third,fourth])
        return [first,second,third,fourth]
    }
    
    func startPoints() -> [CGPoint] {
        return [CGPointMake(0,0),CGPointMake(1,0),CGPointMake(1,1),CGPointMake(0,1)]
    }
    
    func endPoints() -> [CGPoint] {
        return [CGPointMake(1,1),CGPointMake(0,1),CGPointMake(0,0),CGPointMake(1,0)]
    }
    
    func midColorWithFromColor(fromColor:UIColor, toColor:UIColor, progress:CGFloat) -> UIColor {
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        let oneR = fromR + (toR - fromR) * progress
        let oneG = fromG + (toG - fromG) * progress
        let oneB = fromB + (toB - fromB) * progress
        let oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
        return oneColor
    }
    
    // This is what you call if you want to draw a full circle.
    func animateCircle(duration: NSTimeInterval) {
        animateCircleTo(duration, fromValue: 0.010, toValue: 0.999)
    }
    
    // This is what you call to draw a partial circle.
    func animateCircleTo(duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat){
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.removedOnCompletion = true
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0.010 (no circle) to 0.99 (full circle)
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        // Do an easeout. Don't know how to do a spring instead
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 0.99 now so that it's the
        // right value when the animation ends.
        let circleMask = self.mask as! CAShapeLayer
        circleMask.strokeEnd = toValue
        
        // Do the actual animation
        circleMask.removeAllAnimations()
        circleMask.addAnimation(animation, forKey: "animateCircle")
    }
}

