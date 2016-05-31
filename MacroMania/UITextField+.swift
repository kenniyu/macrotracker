//
//  UITextField+.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /**
     Setter and getter for textfield's placeholder color
     */
    public func setPlaceholder(placeholderText: String, withColor color: UIColor) {
        if self.respondsToSelector(Selector("setAttributedPlaceholder:")) {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
    public func isEmpty() -> Bool {
        if let text = self.text where text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != "" {
            return false
        }
        return true
    }
}