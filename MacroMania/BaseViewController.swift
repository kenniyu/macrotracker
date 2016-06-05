//
//  BaseViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/7/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

@objc
public protocol KeyboardDelegate {
    optional func keyboardWillShow(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardWillHide(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardDidShow(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
    optional func keyboardDidHide(keyboardHeight: CGFloat, animationOptions: UIViewAnimationOptions, animationDuration: Double)
}


public class BaseViewController: UIViewController {

    public var keyboardDelegate: KeyboardDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupStyles()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func setupStyles() {
        view.backgroundColor = Styles.Colors.AppBackground
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    public func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
    
    public func navBarHeight() -> CGFloat {
        return navigationController?.navigationBar.height ?? 0
    }
    
    public func topBarHeight() -> CGFloat {
        return statusBarHeight() + navBarHeight()
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

// Keyboard delegate
extension BaseViewController {
    public func getKeyboardNotificationInfo(notification: NSNotification) -> (keyboardHeight: CGFloat, animationCurveOptions: UIViewAnimationOptions, animationDuration: Double)? {
        
        if let keyboardNotificationInfo = notification.userInfo,
            keyboardFrameInfo = keyboardNotificationInfo[UIKeyboardFrameEndUserInfoKey],
            animationCurveInfo = keyboardNotificationInfo[UIKeyboardAnimationCurveUserInfoKey],
            animationDurationInfo = keyboardNotificationInfo[UIKeyboardAnimationDurationUserInfoKey],
            keyboardRect = (keyboardFrameInfo as? NSValue)?.CGRectValue(),
            animationDuration = animationDurationInfo.doubleValue {
            let animationOptions = UIViewAnimationOptions(rawValue:
                UInt(animationCurveInfo.unsignedIntValue << 16))
            return (keyboardRect.height, animationOptions, animationDuration)
        }
        
        return nil
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        guard let keyboardNotificationInfo = getKeyboardNotificationInfo(notification) else { return }
        
        keyboardDelegate?.keyboardWillShow?(
            keyboardNotificationInfo.keyboardHeight,
            animationOptions: keyboardNotificationInfo.animationCurveOptions,
            animationDuration: keyboardNotificationInfo.animationDuration)
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotificationInfo = getKeyboardNotificationInfo(notification) else { return }
        
        keyboardDelegate?.keyboardWillHide?(
            keyboardNotificationInfo.keyboardHeight,
            animationOptions: keyboardNotificationInfo.animationCurveOptions,
            animationDuration: keyboardNotificationInfo.animationDuration)
    }
}