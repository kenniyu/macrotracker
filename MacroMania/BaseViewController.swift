//
//  BaseViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/7/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class BaseViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupStyles()
    }
    
    public func setupStyles() {
        view.backgroundColor = Styles.Colors.AppBackground
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    public func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}