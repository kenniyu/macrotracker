//
//  TodayViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import JTCalendar
import CoreData

public class TodayViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarContainerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calendarContentView: JTVerticalCalendarView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarWeekDayView: JTCalendarWeekDayView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var tableReloadTimer: NSTimer?
    private var calendarManager: JTCalendarManager?
    private var selectedDate: NSDate? = NSDate()
    
    public static let kNibName = "TodayViewController"
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: TodayViewController.kNibName, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Private
    private var cellModels: [TimeMealTableViewCellModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Meal Planner"
        
        setupNavBar()
        
        setupTimer()
        setupCalendar()
        
    }
    
    public override func viewDidLayoutSubviews() {
        calendarContainerViewTopConstraint.constant = topBarHeight()
        setupTableView()
        reloadTableView()
        view.sendSubviewToBack(backgroundImageView)
        
        // Animate in table view
        UIView.animateWithDuration(0.4) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.alpha = 1
//            strongSelf.backgroundImageView.alpha = 1
        }
    }
    
    private func setupTimer() {
        self.tableReloadTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(TodayViewController.reloadTableView), userInfo: nil, repeats: true)
    }
    
    public func reloadTableView() {
        updateCellModels()
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        let addButton = createAddButton()
        addRightBarButtons([addButton])
    }
    
    private func createDate(hour: Int = 0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = 6
        components.day = 2
        components.year = 2016
        components.hour = hour
        components.minute = 0
        let newDate = calendar.dateFromComponents(components)
        if let newDate = newDate {
            return newDate
        } else {
            return NSDate()
        }
    }
    
    private func generateFoodItems(index: Int) -> [FoodItem] {
        switch index {
        case 0:
            let foodItem1 = FoodItem(name: "Protein Powder (1.5 scoops)", fat: 1.5, carbs: 6, protein: 37.5)
            let foodItem2 = FoodItem(name: "Oatmeal (2 cups)", fat: 7, carbs: 60, protein: 10)
            return [foodItem1, foodItem2]
//        case 1:
//            let foodItem1 = FoodItem(name: "Protein Powder (1.5 scoops)", fat: 1.5, carbs: 6, protein: 37.5)
//            let foodItem2 = FoodItem(name: "Oatmeal (2 cups)", fat: 7, carbs: 60, protein: 10)
//            return [foodItem1, foodItem2]
        default:
            let foodItem1 = FoodItem(name: "Chicken Breast (4 oz)", fat: 1.5, carbs: 0, protein: 24)
            let foodItem2 = FoodItem(name: "Oatmeal (1 cup)", fat: 3.5, carbs: 30, protein: 5)
            return [foodItem1, foodItem2]
        }
    }
    
    private func updateCellModels() {
        cellModels = []
        
        for index in 0..<7 {
            let cellModel = TimeMealTableViewCellModel(mealDate: createDate(6 + index * 2), meal: Meal(foodItems: generateFoodItems(index)))
            if index > 0 {
                let prevCellModel = cellModels[index - 1]
                prevCellModel.nextMealDate = cellModel.mealDate
            }
            cellModels.append(cellModel)
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.width, calendarContainerView.height + 20))
        tableView.alpha = 0
    }
    
    private func registerCells() {
        tableView.registerNib(TimeMealTableViewCell.nib, forCellReuseIdentifier: TimeMealTableViewCell.reuseId)
    }
    
    public override func add() {
        let addViewController = AddMealViewController(date: selectedDate)
        let navigationController = UINavigationController(rootViewController: addViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}

// Calendar crap
extension TodayViewController {
    private func setupCalendar() {
        calendarManager = JTCalendarManager()
        calendarManager?.delegate = self
        
        calendarWeekDayView.manager = calendarManager
        calendarWeekDayView.reload()
        
        calendarManager?.settings.pageViewHaveWeekDaysView = false
        calendarManager?.settings.pageViewNumberOfWeeks = 0
        
        calendarManager?.menuView = calendarMenuView
        calendarManager?.contentView = calendarContentView
        calendarManager?.setDate(selectedDate)
        
        calendarMenuView.scrollView.scrollEnabled = false
        
        setupCalendarStyles()
    }
    
    private func setupCalendarStyles() {
        calendarContainerView.backgroundColor = Styles.Colors.AppBackground
        calendarMenuView.backgroundColor = UIColor.clearColor()
        calendarWeekDayView.backgroundColor = UIColor.clearColor()
        calendarContentView.backgroundColor = UIColor.clearColor()
        
        for dayView in calendarWeekDayView.dayViews {
            if let dayViewLabel = dayView as? UILabel {
                dayViewLabel.font = Styles.Fonts.boldFontWithSize(14)
                dayViewLabel.textColor = Styles.Colors.AppLightGray
                if let dayInitial = dayViewLabel.text?.characters.first {
                    dayViewLabel.text = String(dayInitial)
                }
            }
        }
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(TimeMealTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? TimeMealTableViewCell {
            let cellModel = cellModels[indexPath.row]
            cell.setup(cellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TimeMealTableViewCell.size(tableView.width, viewModel: cellModels[indexPath.row]).height
    }
}

extension TodayViewController: JTCalendarDelegate {
    /// this method is used to customize the design of the day view for a specific date. This method is called each time a new date is set in a dayView or each time the current page change. You can force the call to this method by calling
    public func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        dayView.hidden = false
        
        // Test if the dayView is from another month than the page
        // Use only in month mode for indicate the day of the previous or next month
        if let dayView = dayView as? JTCalendarDayView {
            if dayView.isFromAnotherMonth {
                dayView.textLabel.textColor = Styles.Colors.AppBackground
                return
            }
            
            if let dateHelper = calendarManager?.dateHelper {
                
                if let selectedDate = selectedDate where dateHelper.date(selectedDate, isTheSameDayThan: dayView.date) {
                    dayView.circleView.borderWidth = 1.0
                    dayView.circleView.borderColor = Styles.Colors.AppGreen
                } else {
                    dayView.circleView.borderWidth = 0.0
                }
                
                if dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
                    
                    // Today
                    dayView.circleView.hidden = false
                    dayView.circleView.backgroundColor = Styles.Colors.AppGold
                    dayView.dotView.backgroundColor = Styles.Colors.AppGold
                    dayView.textLabel.textColor = Styles.Colors.AppLightGray
                    
                    if let selectedDate = selectedDate where dateHelper.date(selectedDate, isTheSameDayThan: NSDate()) {
                        dayView.textLabel.textColor = UIColor.whiteColor()
                    }
                } else if let selectedDate = selectedDate where dateHelper.date(selectedDate, isTheSameDayThan: dayView.date) {
                    // Selected date
                    if dateHelper.date(selectedDate, isEqualOrBefore: NSDate()) {
                        // if the selected date is before today, highlight it purple
//                        dayView.circleView.backgroundColor = UIColor.clearColor()
                    } else {
                        // selected date is in the future, highlight it blue
//                        dayView.circleView.backgroundColor = Styles.Colors.AppGreen
                    }
                    dayView.circleView.backgroundColor = UIColor.clearColor()
                    dayView.circleView.hidden = false
                    dayView.dotView.backgroundColor = Styles.Colors.AppOrange
                    dayView.textLabel.textColor = Styles.Colors.AppLightGray
                } else {
                    // Another day of the current month
                    dayView.circleView.hidden = true
                    dayView.dotView.backgroundColor = Styles.Colors.AppOrange
                    dayView.textLabel.textColor = Styles.Colors.AppLightGray
                }
            }
        }
    }
    
    /// this method is used to respond to a touch on a dayView. For exemple you can indicate to display another month if dayView is from another month.
    public func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        if let dayView = dayView as? JTCalendarDayView {
            var shouldAnimate = true
            if let dateHelper = calendarManager?.dateHelper where dateHelper.date(NSDate(), isTheSameDayThan: dayView.date) {
                shouldAnimate = false
            }
            selectedDate = dayView.date
            
            if shouldAnimate {
                // Animation for the circleView
                dayView.circleView.alpha = 0
                UIView.transitionWithView(dayView, duration: 0.1, options: .CurveEaseIn, animations: { [weak self] () -> Void in
                    dayView.circleView.alpha = 1
                    self?.calendarManager?.reload()
                }, completion: nil)
            } else {
                calendarManager?.reload()
            }
            
            // Load previous/next month based on selected date
            if let dateHelper = calendarManager?.dateHelper {
                if !dateHelper.date(calendarContentView.date, isTheSameMonthThan: selectedDate) {
                    if calendarContentView.date.compare(dayView.date) == .OrderedAscending {
                        calendarContentView.loadNextPageWithAnimation()
                    } else {
                        calendarContentView.loadPreviousPageWithAnimation()
                    }
                }
            }
        }
        
        return
    }
    
    public func calendarBuildMenuItemView(calendar: JTCalendarManager!) -> UIView! {
        let label = UILabel()
        label.textAlignment = .Center;
        label.textColor = Styles.Colors.AppLightGray
        label.font = Styles.Fonts.boldFontWithSize(16)
        return label
    }
    
    public func calendar(calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: NSDate!) {
        if date != nil {
            if let dateHelper = calendarManager?.dateHelper, calendar = dateHelper.calendar() {
                let desiredComponents = NSCalendarUnit.Year.union(NSCalendarUnit.Month)
                let comps = calendar.components(desiredComponents, fromDate: date)
                var currentMonthIndex = comps.month
                let currentYearIndex = comps.year
                
                if let dateFormatter = dateHelper.createDateFormatter() {
                    dateFormatter.timeZone = calendar.timeZone
                    dateFormatter.locale = calendar.locale
                    
                    while currentMonthIndex <= 0 {
                        currentMonthIndex += 12
                    }
                    
                    let monthText = dateFormatter.standaloneMonthSymbols[currentMonthIndex - 1].uppercaseString
                    let yearText = String(currentYearIndex)
                    if let monthLabel = menuItemView as? UILabel {
                        monthLabel.text = "\(monthText) \(yearText)"
                    }
                }
            }
        }
    }
    
    
    public func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let view = JTCalendarDayView()
        view.textLabel.font = Styles.Fonts.MediumMedium
        view.textLabel.adjustsFontSizeToFitWidth = true
        view.textLabel.minimumScaleFactor = 0.6
        view.textLabel.textColor = Styles.Colors.AppLightGray
        view.circleRatio = 0.75
        view.dotRatio = 1 / 0.9
        
        return view
    }
    
}
