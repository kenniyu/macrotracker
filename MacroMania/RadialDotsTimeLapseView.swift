//
//  RadialDotsTimeLapseView.swift
//  MacroMania
//
//  Created by Ken Yu on 5/8/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class DotViewModel {
    var elapsed: Bool = false
    var index: Int
    var dotView: UIView
    
    public init(index: Int, dotView: UIView, elapsed: Bool = false) {
        self.index = index
        self.elapsed = elapsed
        self.dotView = dotView
    }
}

public class RadialDotsTimeLapseView: UIView {

    public static let kDotViewActiveColor = UIColor.whiteColor()
    public static let kDotViewInactiveColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    
    public var dotsPerMinute = 4
    public var minutesPerCircle = 180
    public var outerRadius: CGFloat = 60
    public var innerRadius: CGFloat = 40
    public var kRadiusRatio: CGFloat = 1.25
    public var dotViewModels: [DotViewModel] = []
    
    public var isSetup = false
    public var dotViewTimer: NSTimer?
    
    public var activeDotIndex: Int = 0

    
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
    
    private func isElapsed(dotIndex: Int, currentDate: NSDate) -> Bool {
        let dotSecondValue = getDotSecondValue(dotIndex)
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let beginningDayDate: NSDate = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: currentDate, options: NSCalendarOptions())!
        
        let elapsedSeconds = currentDate.timeIntervalSinceDate(beginningDayDate)
        
        return dotSecondValue < Int(elapsedSeconds)
    }
    
    private func getDotViewBackgroundColor(dotIndex: Int, currentDate: NSDate) -> UIColor {
        guard dotIndex < dotViewModels.count else { return RadialDotsTimeLapseView.kDotViewInactiveColor }
        
        if dotViewModels[dotIndex].elapsed {
            return RadialDotsTimeLapseView.kDotViewActiveColor
        } else {
            return RadialDotsTimeLapseView.kDotViewInactiveColor
        }
    }
    
    private func getDotSecondValue(dotIndex: Int) -> Int {
        let totalDots = dotsPerMinute * minutesPerCircle
        let totalSeconds = 86400
        let secondsPerDot = totalSeconds/totalDots
        
        return dotIndex * secondsPerDot
    }
    
    
    public func updateDotView() {
        var currentDotViewModel: DotViewModel?
        
        for dotViewModel in dotViewModels {
            if !dotViewModel.elapsed {
                // toggle this view's background color
                currentDotViewModel = dotViewModel
                break
            }
        }
        
        let currentDate = NSDate()
        for (index, dotViewModel) in dotViewModels.enumerate() {
            if let currentDotViewModel = currentDotViewModel where dotViewModel.index == currentDotViewModel.index {
                continue
            }
            dotViewModel.dotView.backgroundColor = getDotViewBackgroundColor(index, currentDate: currentDate)
        }
        
        toggleDotViewBackgroundColor(currentDotViewModel?.dotView)
    }
    
    // TODO: WHY THE FUCK IS THIS NOT WORKING
    public func toggleDotViewBackgroundColor(dotView: UIView?) {
        guard let dotView = dotView, backgroundColor = dotView.backgroundColor else { return }
        if backgroundColor.getAlpha() == RadialDotsTimeLapseView.kDotViewInactiveColor.getAlpha() {
            dotView.backgroundColor = RadialDotsTimeLapseView.kDotViewActiveColor
        } else {
            dotView.backgroundColor = RadialDotsTimeLapseView.kDotViewInactiveColor
        }
        
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
                
                // Get radians. Reverse direction and add M_PI
                let radians = Double(-1 * minute * degreeMultiplier) * M_PI/180 + M_PI
                let radius = innerRadius + CGFloat(CGFloat(dot) / CGFloat(dotsPerMinute)) * radialDifference
                
                dotView.center.x = center.x + radius * CGFloat(sin(radians))
                dotView.center.y = center.y + radius * CGFloat(cos(radians))
                
                let dotIndex = minute * dotsPerMinute + dot
                dotView.backgroundColor = getDotViewBackgroundColor(dotIndex, currentDate: currentDate)
                addSubview(dotView)
                
                let elapsed = isElapsed(dotIndex, currentDate: currentDate)
                let dotViewModel = DotViewModel(index: dotIndex, dotView: dotView, elapsed: elapsed)
                
                dotViewModels.append(dotViewModel)
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
