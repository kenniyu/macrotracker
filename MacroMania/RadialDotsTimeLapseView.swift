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
    public var ringView: UIView?
    
    public var fatMeterWrapperView: UIView?
    public var carbsMeterWrapperView: UIView?
    public var proteinMeterWrapperView: UIView?
    
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
        
        fatMeterWrapperView = UIView(frame: view.frame)
        view.addSubview(fatMeterWrapperView!)
        carbsMeterWrapperView = UIView(frame: view.frame)
        view.addSubview(carbsMeterWrapperView!)
        proteinMeterWrapperView = UIView(frame: view.frame)
        view.addSubview(proteinMeterWrapperView!)
        
        // Add subview
        addSubview(view)
        
        layoutIfNeeded()
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.alpha = 0
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
        let currentDate = NSDate()
        
        // Update elapsed state but also get the most recent one
        for (index, dotViewModel) in dotViewModels.enumerate() {
            let elapsed = isElapsed(index, currentDate: currentDate)
            dotViewModel.elapsed = elapsed
            
            if !dotViewModel.elapsed {
                // toggle this view's background color
                currentDotViewModel = dotViewModel
                break
            }
        }
        
        for (index, dotViewModel) in dotViewModels.enumerate() {
            if let currentDotViewModel = currentDotViewModel where dotViewModel.index == currentDotViewModel.index {
                continue
            }
            dotViewModel.dotView.backgroundColor = getDotViewBackgroundColor(index, currentDate: currentDate)
        }
        
        toggleDotViewBackgroundColor(currentDotViewModel?.dotView)
    }
    
    public func toggleDotViewBackgroundColor(dotView: UIView?) {
        guard let dotView = dotView, backgroundColor = dotView.backgroundColor else { return }
        if backgroundColor.getAlpha() == RadialDotsTimeLapseView.kDotViewInactiveColor.getAlpha() {
            dotView.backgroundColor = RadialDotsTimeLapseView.kDotViewActiveColor
        } else {
            dotView.backgroundColor = RadialDotsTimeLapseView.kDotViewInactiveColor
        }
        
    }
    
    public func setup() {
        startRotate(60)
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
        
        setupInnerRing()
        fadeIn()
        dotViewTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(RadialDotsTimeLapseView.updateDotView), userInfo: nil, repeats: true)
    }
    
    public func setupInnerRing() {
        let lineWidth: CGFloat = 1
        let shapelayer = CAShapeLayer()
        let outerPadding: CGFloat = 8
        let radius = innerRadius - outerPadding
        let rect = CGRectMake(self.bounds.width/2 - radius,
                              self.bounds.height/2 - radius,
                              2 * radius - 2 * lineWidth, 2 * radius - 2 * lineWidth)
        shapelayer.bounds = rect
        shapelayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)
        shapelayer.strokeColor = UIColor.whiteColor().CGColor
        shapelayer.fillColor = UIColor.clearColor().CGColor
        shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: CGRectGetWidth(rect)/2).CGPath
        shapelayer.lineWidth = lineWidth
        shapelayer.lineCap = kCALineCapButt
        shapelayer.strokeStart = 0
        
        shapelayer.strokeEnd = 1
        
        layer.addSublayer(shapelayer)
    }
    
    public func setupMacroRings(macroRatios: [CGFloat]) {
        fatMeterWrapperView?.layer.sublayers = nil
        carbsMeterWrapperView?.layer.sublayers = nil
        proteinMeterWrapperView?.layer.sublayers = nil
        
        for (index, macro) in macroRatios.enumerate() {
            let lineWidth: CGFloat = 3
            let shapelayer = CAShapeLayer()
            let outerPadding: CGFloat = 8 + CGFloat(index) * (lineWidth + 1)
            
            let radius = innerRadius - outerPadding
            let rect = CGRectMake(self.bounds.width/2 - radius,
                                  self.bounds.height/2 - radius,
                                  2 * radius - 2 * lineWidth,
                                  2 * radius - 2 * lineWidth)
            shapelayer.bounds = rect
            shapelayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: CGRectGetWidth(rect)/2).CGPath
            shapelayer.lineWidth = lineWidth
            shapelayer.lineCap = kCALineCapButt
            shapelayer.strokeStart = 0
            shapelayer.strokeEnd = macro
            
            switch index {
            case 0:
                shapelayer.strokeColor = Styles.Colors.AppRed.CGColor
                fatMeterWrapperView?.layer.addSublayer(shapelayer)
                fatMeterWrapperView?.rotate("fatMeterWrapperViewAnimation", duration: Double(macro * 60))
            case 1:
                shapelayer.strokeColor = Styles.Colors.AppGreen.CGColor
                carbsMeterWrapperView?.layer.addSublayer(shapelayer)
                carbsMeterWrapperView?.rotate("carbsMeterWrapperViewAnimation", duration: Double(macro * 60))
            case 2:
                shapelayer.strokeColor = Styles.Colors.AppOrange.CGColor
                proteinMeterWrapperView?.layer.addSublayer(shapelayer)
                proteinMeterWrapperView?.rotate("proteinMeterWrapperViewAnimation", duration: Double(macro * 60))
            default:
                break
            }
        }
    }
    
    public func stop() {
        dotViewTimer?.invalidate()
        dotViewTimer = nil
    }
    
    public func fadeIn() {
        UIView.animateWithDuration(2.0, delay: 1.0, options: .CurveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1
        }) { (Bool) in
            // Do anything there?
            return
        }
    }
    
    public func startRotate(duration: Double) {
        self.rotate("radialViewAnimation", duration: duration)
    }
}
