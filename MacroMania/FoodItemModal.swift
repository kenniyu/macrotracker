//
//  FoodItemModal.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import UIKit

public protocol FoodItemModalDelegate {
    func didTapDone(foodName: String, fat: Double, carbs: Double, protein: Double)
    func didTapClose()
}

public class FoodItemModal: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var modalTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodNameTextFieldBottomBorderView: UIView!
    
    @IBOutlet weak var fatView: UIView!
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var proteinView: UIView!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    
    @IBOutlet weak var fatTextFieldBottomBorderView: UIView!
    @IBOutlet weak var carbsTextFieldBottomBorderView: UIView!
    @IBOutlet weak var proteinTextFieldBottomBorderView: UIView!
    
    @IBOutlet weak var doneButtonContainer: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    public var foodItemModalDelegate: FoodItemModalDelegate?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FoodItemModal", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        // Adjust bounds
        view.frame = self.bounds
        
        // Add subview
        addSubview(view)
        
        layoutIfNeeded()
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = Styles.Colors.AppBackground
    }
    
    public func setup() {
        setupStyles()
    }
    
    private func setupStyles() {
        // Background colors
        topBarView.backgroundColor = Styles.Colors.AppBackground
        modalTitleLabel.textColor = Styles.Colors.AppLightGray
        modalTitleLabel.font = Styles.Fonts.BookLarge
        
        foodNameTextField.backgroundColor = Styles.Colors.AppBackground
        fatTextField.backgroundColor = Styles.Colors.AppBackground
        carbsTextField.backgroundColor = Styles.Colors.AppBackground
        proteinTextField.backgroundColor = Styles.Colors.AppBackground
        
        fatLabel.backgroundColor = UIColor.clearColor()
        carbsLabel.backgroundColor = UIColor.clearColor()
        proteinLabel.backgroundColor = UIColor.clearColor()
        
        fatLabel.font = Styles.Fonts.MediumXSmall
        carbsLabel.font = Styles.Fonts.MediumXSmall
        proteinLabel.font = Styles.Fonts.MediumXSmall
        
        fatLabel.textColor = Styles.Colors.AppLightGray
        carbsLabel.textColor = Styles.Colors.AppLightGray
        proteinLabel.textColor = Styles.Colors.AppLightGray
        
        fatLabel.text = fatLabel.text?.uppercaseString
        carbsLabel.text = carbsLabel.text?.uppercaseString
        proteinLabel.text = proteinLabel.text?.uppercaseString
        
        foodNameTextField.setPlaceholder("Name, ie. Chicken Breast", withColor: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        carbsTextField.setPlaceholder("0", withColor: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        fatTextField.setPlaceholder("0", withColor: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        proteinTextField.setPlaceholder("0", withColor: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        
        fatTextField.keyboardType = .NumberPad
        carbsTextField.keyboardType = .NumberPad
        proteinTextField.keyboardType = .NumberPad
        
        foodNameTextField.textColor = Styles.Colors.AppOrange
        fatTextField.textColor = Styles.Colors.AppOrange
        carbsTextField.textColor = Styles.Colors.AppOrange
        proteinTextField.textColor = Styles.Colors.AppOrange
        
        foodNameTextField.font = Styles.Fonts.MediumLarge
        foodNameTextFieldBottomBorderView.backgroundColor = Styles.Colors.AppGray
        
        fatTextField.font = Styles.Fonts.MediumXXXLarge
        fatTextFieldBottomBorderView.backgroundColor = Styles.Colors.AppGray
        
        carbsTextField.font = Styles.Fonts.MediumXXXLarge
        carbsTextFieldBottomBorderView.backgroundColor = Styles.Colors.AppGray
        
        proteinTextField.font = Styles.Fonts.MediumXXXLarge
        proteinTextFieldBottomBorderView.backgroundColor = Styles.Colors.AppGray
        
        
        doneButton.titleLabel?.font = Styles.Fonts.MediumMedium!
        doneButton.setTitle(doneButton.titleLabel?.text?.uppercaseString, forState: .Normal)
        doneButton.tintColor = UIColor.whiteColor()
        
        // Set backgrounds for states
        doneButton.setBackgroundImage(UIImage().imageWithColor(Styles.Colors.AppLightGray.colorWithAlphaComponent(0.5), size: frame.size), forState: .Disabled)
        doneButton.setBackgroundImage(UIImage().imageWithColor(Styles.Colors.AppGreen, size: frame.size), forState: .Normal)
        
        doneButton.enabled = false
        
    }
    
    private func validateFields() {
        if foodNameTextField.text != "" && fatTextField.text != "" && carbsTextField.text != "" && proteinTextField.text != "" {
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
    }
    
    @IBAction func tappedClose() {
        foodItemModalDelegate?.didTapClose()
    }
    
    @IBAction func tappedDone() {
        guard let foodName = foodNameTextField.text,
        fat = fatTextField.text,
        carbs = carbsTextField.text,
            protein = proteinTextField.text, doubleFat = Double(fat), doubleCarbs = Double(carbs), doubleProtein = Double(protein) else { return }
        
        foodItemModalDelegate?.didTapDone(foodName, fat: doubleFat, carbs: doubleCarbs, protein: doubleProtein)
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        validateFields()
    }
}