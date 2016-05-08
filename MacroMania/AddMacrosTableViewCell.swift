//
//  AddMacrosTableViewCell.swift
//  MacroMania
//
//  Created by Ken Yu on 5/7/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit


public class AddMacrosTableViewCellModel {
    var macro: Double?
    var name: String?
    
    public init(name: String?, macro: Double) {
        self.name = name
        self.macro = macro
    }
}


public class AddMacrosTableViewCell: UITableViewCell {
    // IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    // Class
    static let kClassName = "AddMacrosTableViewCell"
    static let kReuseIdentifier = "AddMacrosTableViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: AddMacrosTableViewCell.self))
    static let kTextFieldHeight: CGFloat = 40
    static let kTitleLabelHeight: CGFloat = 20
    static let kCellVerticalPadding: CGFloat = 20
    static let kCellHorizontalPadding: CGFloat = 20
    static let kButtonWidth: CGFloat = 40
    
    public var viewModel: AddMacrosTableViewCellModel!

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    public class var nib: UINib {
        get {
            return AddMacrosTableViewCell.kNib
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public class var reuseId: String {
        get {
            return AddMacrosTableViewCell.kClassName
        }
    }
    
    public func setup(viewModel: AddMacrosTableViewCellModel) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.clearColor()
        
        textField.font = Styles.Fonts.ThinXXXXLarge
        textField.textColor = Styles.Colors.AppSilver
        textField.keyboardType = .DecimalPad
        
        titleLabel.font = Styles.Fonts.ThinMedium
        titleLabel.textColor = Styles.Colors.AppGray
        
        textField.textAlignment = .Center
        titleLabel.textAlignment = .Center
        
        // Setup button tint
        minusButton.tintColor = Styles.Colors.AppOrange
        plusButton.tintColor = Styles.Colors.AppOrange
        
        selectionStyle = .None
        separatorInset = UIEdgeInsetsMake(0, containerView.width, 0, 0)
        
        loadDataIntoViews(viewModel)
        hideUnhideViews()
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // set cell container frame
        containerView.frame = bounds
        containerView.backgroundColor = UIColor.clearColor()
        setSubviewFrames()
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: AddMacrosTableViewCellModel) -> CGSize {
        var cellHeight: CGFloat = 0
        
        // add cell spacing
        cellHeight += 2 * AddMacrosTableViewCell.kCellVerticalPadding
        cellHeight += AddMacrosTableViewCell.kTitleLabelHeight
        cellHeight += Styles.Dimensions.kItemSpacingDim2
        cellHeight += AddMacrosTableViewCell.kTextFieldHeight
        
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    public func setSubviewFrames() {
        titleLabel.width = containerView.width - 2 * AddMacrosTableViewCell.kCellHorizontalPadding
        titleLabel.height = AddMacrosTableViewCell.kTitleLabelHeight
        titleLabel.top = AddMacrosTableViewCell.kCellVerticalPadding
        titleLabel.center.x = containerView.center.x
        
        textField.width = containerView.width - 4 * AddMacrosTableViewCell.kCellHorizontalPadding - 2 * AddMacrosTableViewCell.kButtonWidth
        textField.height = AddMacrosTableViewCell.kButtonWidth
        textField.center.x = containerView.center.x
        textField.top = titleLabel.bottom + Styles.Dimensions.kItemSpacingDim2
        
        minusButton.width = AddMacrosTableViewCell.kButtonWidth
        minusButton.height = minusButton.width
        minusButton.center.y = textField.center.y
        minusButton.left = AddMacrosTableViewCell.kCellHorizontalPadding
        
        plusButton.width = AddMacrosTableViewCell.kButtonWidth
        plusButton.height = plusButton.width
        plusButton.center.y = textField.center.y
        plusButton.right = containerView.width - AddMacrosTableViewCell.kCellHorizontalPadding
    }

    public func setupA11yIdentifiers() {
        // setup accessibility
    }
    
    public func loadDataIntoViews(viewModel: AddMacrosTableViewCellModel) {
        if let name = viewModel.name {
            titleLabel.text = name.uppercaseString
        }
        
        if let macro = viewModel.macro {
            textField.text = "\(macro)"
        }
    }
    
    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }
    
    public func updateTextField() {
        guard let macro = viewModel.macro else { return }
        textField.text = "\(macro)"
    }
    
    @IBAction func plusTapped(sender: UIButton) {
        guard let macro = viewModel.macro else { return }
        let newMacro = macro + 1
        viewModel.macro = newMacro
        updateTextField()
    }
    
    @IBAction func minusTapped(sender: UIButton) {
        guard let macro = viewModel.macro else { return }
        viewModel.macro = max(0, macro - 1)
        updateTextField()
    }
}

extension AddMacrosTableViewCell: UITextFieldDelegate {
    @IBAction func editingChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.macro = Double(text) ?? 0
    }
}
