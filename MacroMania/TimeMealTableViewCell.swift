//
//  TimeMealTableViewCell.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class TimeMealTableViewCellModel {
    var mealDate: NSDate
    var meal: Meal
    var nextMealDate: NSDate?
    
    public init(mealDate: NSDate, meal: Meal, nextMealDate: NSDate? = nil) {
        self.mealDate = mealDate
        self.meal = meal
        self.nextMealDate = nextMealDate
    }
}


public class TimeMealTableViewCell: UITableViewCell {
    // IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mealDateLabel: UILabel!
    @IBOutlet weak var mealContentLabel: UILabel!
    @IBOutlet weak var milestoneView: UIView!
    @IBOutlet weak var timeTrackView: UIView!
    @IBOutlet weak var currentTimeTrackView: UIView!
    
    // Class
    static let kClassName = "TimeMealTableViewCell"
    static let kReuseIdentifier = "TimeMealTableViewCell"
    static let kNib = UINib(nibName: kClassName, bundle: NSBundle(forClass: TimeMealTableViewCell.self))
    static let kTimeLabelWidth: CGFloat = 80
    static let kTimeLabelHeight: CGFloat = 20
    static let kCellVerticalPadding: CGFloat = 20
    static let kCellHorizontalPadding: CGFloat = 20
    static let kTimeTrackViewWidth: CGFloat = 2
    static let kMilestoneViewWidth: CGFloat = 12
    static let kMilestoneViewMargin: CGFloat = Styles.Dimensions.kItemSpacingDim3
    static let kMealContentLabelFont: UIFont = Styles.Fonts.BookMedium!
    static let kMealDateLabelFont: UIFont = Styles.Fonts.ThinMedium!
    
    // Public
    public var viewModel: TimeMealTableViewCellModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public class var nib: UINib {
        get {
            return TimeMealTableViewCell.kNib
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public class var reuseId: String {
        get {
            return TimeMealTableViewCell.kClassName
        }
    }
    
    public func setup(viewModel: TimeMealTableViewCellModel) {
        self.viewModel = viewModel
        self.backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
        separatorInset = UIEdgeInsetsMake(0, containerView.width, 0, 0)
        
        mealDateLabel.font = TimeMealTableViewCell.kMealDateLabelFont
        mealContentLabel.font = TimeMealTableViewCell.kMealContentLabelFont
        mealDateLabel.textColor = Styles.Colors.AppGold
        mealContentLabel.textColor = UIColor.whiteColor()
        
        timeTrackView.backgroundColor = Styles.Colors.AppGray
        milestoneView.backgroundColor = Styles.Colors.AppGray
        currentTimeTrackView.backgroundColor = Styles.Colors.AppGreen
        
        milestoneView.borderColor = UIColor.whiteColor()
        milestoneView.borderWidth = 1.5
        
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
    
    public func updateMealTimeTrackView() {
        if let nextMealDate = viewModel.nextMealDate {
            let currentTime = NSDate()
            let secondsDiff = nextMealDate.timeIntervalSinceDate(viewModel.mealDate)
            let secondsElapsed = currentTime.timeIntervalSinceDate(viewModel.mealDate)
            currentTimeTrackView.height = max(0, min(containerView.height * CGFloat(secondsElapsed)/CGFloat(secondsDiff), containerView.height))
            milestoneView.backgroundColor = secondsElapsed < 0 ? Styles.Colors.AppGray : Styles.Colors.AppGreen
        } else {
            currentTimeTrackView.height = 0
            milestoneView.backgroundColor = Styles.Colors.AppGray
        }
    }
    
    public class func size(boundingWidth: CGFloat, viewModel: TimeMealTableViewCellModel) -> CGSize {
        var cellHeight: CGFloat = 0
        let trueBoundingWidth = boundingWidth - kTimeLabelWidth - 2 * TimeMealTableViewCell.kMilestoneViewMargin - kMilestoneViewWidth - Styles.Dimensions.kItemSpacingDim2
        
        let mealText = getMealText(viewModel)
        let mealAttributedText = getAttributedTitleString(mealText)
        let mealLabelHeight = getLabelHeight(trueBoundingWidth, viewModel: viewModel, attributedText: mealAttributedText)
        cellHeight = mealLabelHeight + TimeMealTableViewCell.kCellVerticalPadding

        return CGSizeMake(boundingWidth, cellHeight)
    }
    
    public class func getMealText(viewModel: TimeMealTableViewCellModel) -> String {
        let foodNames = viewModel.meal.foodItems.map({ (foodItem) -> String in
            return foodItem.name
        })
        return foodNames.joinWithSeparator("\n")
    }
    
    public func setSubviewFrames() {
        mealDateLabel.width = TimeMealTableViewCell.kTimeLabelWidth
        mealDateLabel.height = TimeMealTableViewCell.kTimeLabelHeight
        mealDateLabel.left = 0
        mealDateLabel.top = 0
        
        milestoneView.width = TimeMealTableViewCell.kMilestoneViewWidth
        milestoneView.height = TimeMealTableViewCell.kMilestoneViewWidth
        milestoneView.top = 0
        milestoneView.left = mealDateLabel.right + TimeMealTableViewCell.kMilestoneViewMargin
        milestoneView.cornerRadius = milestoneView.width/2
        
        mealContentLabel.width = containerView.width - milestoneView.right - TimeMealTableViewCell.kMilestoneViewMargin - Styles.Dimensions.kItemSpacingDim2
        mealContentLabel.height = containerView.height - TimeMealTableViewCell.kCellVerticalPadding
        mealContentLabel.top = 0
        mealContentLabel.left = milestoneView.right + TimeMealTableViewCell.kMilestoneViewMargin
        
        timeTrackView.width = TimeMealTableViewCell.kTimeTrackViewWidth
        timeTrackView.height = containerView.height
        timeTrackView.center.x = milestoneView.center.x
        timeTrackView.top = 0
        
        currentTimeTrackView.width = timeTrackView.width
        currentTimeTrackView.height = timeTrackView.height/2
        currentTimeTrackView.top = 0
        currentTimeTrackView.left = timeTrackView.left
        
        updateMealTimeTrackView()
    }
    
    public func setupA11yIdentifiers() {
        // setup accessibility
    }
    
    public func loadDataIntoViews(viewModel: TimeMealTableViewCellModel) {
        let mealText = TimeMealTableViewCell.getMealText(viewModel)
        mealContentLabel.attributedText = TimeMealTableViewCell.getAttributedTitleString(mealText)
        
        mealDateLabel.text = formattedMealDate(viewModel.mealDate)
    }
    
    public func formattedMealDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    public func hideUnhideViews() {
        //        topBorderView.hidden = !style.showTopBorder
    }
    
    public class func getLabelHeight(boundingWidth: CGFloat, viewModel: TimeMealTableViewCellModel, attributedText: NSMutableAttributedString? = nil) -> CGFloat {
        let textHeight = TextUtils.textHeight(attributedText?.string ?? "", font: TimeMealTableViewCell.kMealContentLabelFont, boundingWidth: boundingWidth, numberOfLines: 0, attributedText: attributedText)
        return textHeight
    }
    
    public class func getAttributedTitleString(text: String?) -> NSMutableAttributedString? {
        guard let text = text else { return nil }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName,
                                value: paragraphStyle,
                                range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName,
                                value: TimeMealTableViewCell.kMealContentLabelFont,
                                range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
}