//
//  FoodItemModalViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public protocol FoodItemModalViewControllerDelegate {
    func didAddFoodItem(name: String, fat: Double, carbs: Double, protein: Double)
}

public
class FoodItemModalViewController: BaseViewController {

    @IBOutlet weak var foodItemModal: FoodItemModal!
    
    public static let kNibName = "FoodItemModalViewController"
    public var foodItemModalViewControllerDelegate: FoodItemModalViewControllerDelegate?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .OverCurrentContext
        modalTransitionStyle = .CrossDissolve
    }
    
    public convenience init() {
        self.init(nibName: FoodItemModalViewController.kNibName, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    public override func setupStyles() {
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    public func setup() {
        foodItemModal.setup()
        foodItemModal.foodItemModalDelegate = self
    }
}

extension FoodItemModalViewController: FoodItemModalDelegate {
    public func didTapDone(foodName: String, fat: Double, carbs: Double, protein: Double) {
        foodItemModalViewControllerDelegate?.didAddFoodItem(foodName, fat: fat, carbs: carbs, protein: protein)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func didTapClose() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}