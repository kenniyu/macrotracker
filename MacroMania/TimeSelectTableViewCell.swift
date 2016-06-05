//
//  TimeSelectTableViewCell.swift
//  MacroMania
//
//  Created by Ken Yu on 6/5/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class TimeSelectModel {
    var time: NSDate
    var isSelected: Bool = false
    
    public init(time: NSDate, isSelected: Bool = false) {
        self.time = time
        self.isSelected = isSelected
    }
}

public class TimeSelectTableViewCellModel {
    var timeSelectModels: [TimeSelectModel] = []
    
    public init(timeSelectModels: [TimeSelectModel] = []) {
        self.timeSelectModels = timeSelectModels
    }
}

public class TimeSelectTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var selectButton4: UIButton!
    
    // Class
    static let kClassName = "TimeSelectTableViewCell"
    static let kReuseIdentifier = "TimeSelectTableViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: TimeMealTableViewCell.self))
    static let kCellVerticalPadding: CGFloat = 16
    static let kCellHorizontalPadding: CGFloat = 40
    static let kTimeLabelFont: UIFont = Styles.Fonts.BookMedium!
    static let kButtonWidth: CGFloat = 24
    static let kSelectedImage = UIImage.imageWithColor(Styles.Colors.AppGreen.colorWithAlphaComponent(0.5), size: CGSizeMake(TimeSelectTableViewCell.kButtonWidth, TimeSelectTableViewCell.kButtonWidth))
    static let kDeselectedImage = UIImage.imageWithColor(UIColor.clearColor(), size: CGSizeMake(TimeSelectTableViewCell.kButtonWidth, TimeSelectTableViewCell.kButtonWidth))
    
    // Public
    public var viewModel: TimeSelectTableViewCellModel!
    public var timeSelectButtons: [UIButton] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public class var nib: UINib {
        get {
            return TimeSelectTableViewCell.kNib
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public class var reuseId: String {
        get {
            return TimeSelectTableViewCell.kClassName
        }
    }
    
    public func setup(viewModel: TimeSelectTableViewCellModel) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
        separatorInset = UIEdgeInsetsMake(0, containerView.width, 0, 0)
        
        selectButton.titleLabel?.font = TimeSelectTableViewCell.kTimeLabelFont
        selectButton.titleLabel?.textColor = UIColor.whiteColor()
        selectButton2.titleLabel?.font = TimeSelectTableViewCell.kTimeLabelFont
        selectButton2.titleLabel?.textColor = UIColor.whiteColor()
        selectButton3.titleLabel?.font = TimeSelectTableViewCell.kTimeLabelFont
        selectButton3.titleLabel?.textColor = UIColor.whiteColor()
        selectButton4.titleLabel?.font = TimeSelectTableViewCell.kTimeLabelFont
        selectButton4.titleLabel?.textColor = UIColor.whiteColor()
        
        timeSelectButtons = [selectButton, selectButton2, selectButton3, selectButton4]
        
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
    
    public class func size(boundingWidth: CGFloat, viewModel: TimeSelectTableViewCellModel) -> CGSize {
        var cellHeight: CGFloat = 0
        cellHeight = 2 * TimeSelectTableViewCell.kCellVerticalPadding
        cellHeight += TimeSelectTableViewCell.kButtonWidth
        
        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    public func setSubviewFrames() {
        selectButton.height = containerView.height
        selectButton.width = containerView.width/4
        selectButton.left = 0
        selectButton.top = 0
        
        selectButton2.height = containerView.height
        selectButton2.width = containerView.width/4
        selectButton2.left = selectButton.right
        selectButton2.top = 0
        
        selectButton3.height = containerView.height
        selectButton3.width = containerView.width/4
        selectButton3.left = selectButton2.right
        selectButton3.top = 0
        
        selectButton4.height = containerView.height
        selectButton4.width = containerView.width/4
        selectButton4.left = selectButton3.right
        selectButton4.top = 0
    }
    
    public func setupA11yIdentifiers() {
        // setup accessibility
    }
    
    public func loadDataIntoViews(viewModel: TimeSelectTableViewCellModel) {
        updateButtons()
        
        for (index, button) in timeSelectButtons.enumerate() {
            let timeModel = viewModel.timeSelectModels[index]
            button.setTitle(formattedMealDate(timeModel.time), forState: .Normal)
        }
    }
    
    public func updateButtons() {
        for (index, button) in timeSelectButtons.enumerate() {
            let timeModel = viewModel.timeSelectModels[index]
            button.backgroundColor = timeModel.isSelected ? Styles.Colors.AppGreen : UIColor.clearColor()
        }
    }
    
    public func formattedMealDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    public func hideUnhideViews() {
    }
    
    @IBAction func tappedSelectButton(sender: UIButton) {
        for (index, button) in timeSelectButtons.enumerate() {
            if button == sender {
                viewModel.timeSelectModels[index].isSelected = !viewModel.timeSelectModels[index].isSelected
            }
        }
        updateButtons()
    }
}