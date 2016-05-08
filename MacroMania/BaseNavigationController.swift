//
//  BaseNavigationController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/8/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class BaseNavigationController: UINavigationController {

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
