//
//  RadialDotsTimeLapseView.swift
//  MacroMania
//
//  Created by Ken Yu on 5/8/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class RadialDotsTimeLapseView: UIView {

    public var dotsPerMinute = 4
    public var minutesPerCircle = 180
    public var outerRadius: CGFloat = 60
    public var innerRadius: CGFloat = 40
    public var kRadiusRatio: CGFloat = 1.25
    public var dotViews: [UIView] = []
    
    public var isSetup = false
    public var dotViewTimer: NSTimer?

    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RadialDotsTimeLapseView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        // Adjust bounds
        view.frame = self.bounds
        view.backgroundColor = UIColor.clearColor()
        
        // Add subview
        addSubview(view)
        
        layoutIfNeeded()
        
//        2160
        
        // 86400
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    private func getDotViewBackgroundColor(dotIndex: Int, currentDate: NSDate) -> UIColor {
        let dotSecondValue = getDotSecondValue(dotIndex)
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let beginningDayDate: NSDate = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: currentDate, options: NSCalendarOptions())!
        
        let elapsedSeconds = currentDate.timeIntervalSinceDate(beginningDayDate)
        
        if dotSecondValue < Int(elapsedSeconds) {
            return UIColor.whiteColor()
        } else {
            return UIColor.whiteColor().colorWithAlphaComponent(0.5)
        }
    }
    
    private func getDotSecondValue(dotIndex: Int) -> Int {
        let totalDots = dotsPerMinute * minutesPerCircle
        let totalSeconds = 86400
        let secondsPerDot = totalSeconds/totalDots
        
        return dotIndex * secondsPerDot
    }
    
    
    public func updateDotView() {
        print("Updating")
    }
    
    public func setup() {
        guard isSetup == false else { return }
        
        let currentDate: NSDate = NSDate()
        
        outerRadius = width/2
        innerRadius = outerRadius / kRadiusRatio
        let radialDifference = outerRadius - innerRadius
        for minute in 0...minutesPerCircle - 1 {
            let degreeMultiplier = 360 / minutesPerCircle
            for dot in 0...dotsPerMinute - 1 {
                let dotView = UIView(frame: CGRectMake(0, 0, 2, 2))
                dotView.cornerRadius = 1
                
                let radians = Double(-1 * minute * degreeMultiplier) * M_PI/180 + M_PI
                let radius = innerRadius + CGFloat(CGFloat(dot) / CGFloat(dotsPerMinute)) * radialDifference
                
                dotView.center.x = center.x + radius * CGFloat(sin(radians))
                dotView.center.y = center.y + radius * CGFloat(cos(radians))
                
                let dotIndex = minute * dotsPerMinute + dot
                dotView.backgroundColor = getDotViewBackgroundColor(dotIndex, currentDate: currentDate)
                addSubview(dotView)
                
                dotViews.append(dotView)
            }
        }
        
        isSetup = true
        
        dotViewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(RadialDotsTimeLapseView.updateDotView), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        dotViewTimer?.invalidate()
        dotViewTimer = nil
    }
}
