//
//  GridBackgroundView.swift
//  MacroMania
//
//  Created by Ken Yu on 5/12/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public class GridBackgroundView: UIView {
    @IBOutlet weak var view: UIView!

    public var didSetup = false
    public var kNumSquaresMin = 20
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GridBackgroundView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        // Adjust bounds
        view.frame = self.bounds
        view.backgroundColor = UIColor.clearColor()
        
        // Add subview
        addSubview(view)
        
        layoutIfNeeded()
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    public func setup() {
        if !didSetup {
            drawLines()
            didSetup = true
        }
    }
    
    public func drawLines() {
        // vertical lines
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetStrokeColorWithColor(context, Styles.Colors.AppGold.CGColor)
//        CGContextSetLineWidth(context, 1)
        
        let gridWidth = bounds.width/CGFloat(kNumSquaresMin)
        
        var kNumSquaresX = Int(kNumSquaresMin)
        var kNumSquaresY = Int(bounds.height/gridWidth)
        
        if bounds.width > bounds.height {
            kNumSquaresY = Int(kNumSquaresMin)
            kNumSquaresX = Int(bounds.width/gridWidth)
        }
        
        for squareIndex in 0..<kNumSquaresX {
            let view = UIView(frame: CGRectMake(CGFloat(squareIndex) * gridWidth, 0, 1, height))
            view.backgroundColor = Styles.Colors.AppGold.colorWithAlphaComponent(0.05)
            addSubview(view)
        }
        
        for squareIndex in 0..<kNumSquaresY {
            let view = UIView(frame: CGRectMake(0, CGFloat(squareIndex) * gridWidth, width, 1))
            view.backgroundColor = Styles.Colors.AppGold.colorWithAlphaComponent(0.05)
            addSubview(view)
        }
    }
}