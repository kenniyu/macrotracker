//
//  AddMealViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit
import CoreData

public class AddMealViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroStateView: UIView!
    @IBOutlet weak var zeroStateLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    public static let kNibName = "AddMealViewController"
    
    private var date: NSDate?
    private var cellModels: [TimeSelectTableViewCellModel] = []
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    public convenience init(date: NSDate? = nil) {
        self.init(nibName: AddMealViewController.kNibName, bundle: nil)
        self.date = date
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        if let date = date {
            title = "Meal Times for \(formattedDate(date))"
        }
        view.backgroundColor = Styles.Colors.AppBackground
        
        setupNavBar()
        setupTableView()
        setupZeroStateView()
        
        toggleZeroStateView(false)
        
        updateCellModels()
        tableView.reloadData()
    }
    
    public func formattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    public override func setupStyles() {
        zeroStateLabel.font = Styles.Fonts.ThinLarge
        zeroStateLabel.textColor = Styles.Colors.AppLightGray
        addButton.titleLabel?.font = Styles.Fonts.MediumLarge
        addButton.tintColor = Styles.Colors.AppGold
    }
    
    private func toggleZeroStateView(showZeroState: Bool) {
        tableView.hidden = showZeroState
        zeroStateView.hidden = !showZeroState
    }
    
    private func setupZeroStateView() {
        zeroStateView.backgroundColor = UIColor.clearColor()
    }
    
    private func registerCells() {
        tableView.registerNib(TimeSelectTableViewCell.nib, forCellReuseIdentifier: TimeSelectTableViewCell.reuseId)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        registerCells()
    }
    
    private func setupNavBar() {
        let doneButton = createDoneButton()
        addRightBarButtons([doneButton])
        addCloseButton()
    }
    
    public override func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func updateCellModels() {
        cellModels = []
        guard let date = date else { return }
        guard let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian) else { return }
        

        for hour in 0..<12 {
            var currentHour = hour * 2
            let components = calendar.components([.Month, .Day, .Hour], fromDate: date)
            components.hour = currentHour
            guard let newDate = calendar.dateFromComponents(components) else { continue }
            components.minute = 30
            guard let newDate2 = calendar.dateFromComponents(components) else { continue }
            
            currentHour += 1
            components.hour = currentHour
            components.minute = 0
            guard let newDate3 = calendar.dateFromComponents(components) else { continue }
            
            components.hour = currentHour
            components.minute = 30
            guard let newDate4 = calendar.dateFromComponents(components) else { continue }
            
            let timeSelectModels = [
                TimeSelectModel(time: newDate, isSelected: false),
                TimeSelectModel(time: newDate2, isSelected: false),
                TimeSelectModel(time: newDate3, isSelected: false),
                TimeSelectModel(time: newDate4, isSelected: false)
            ]
            let cellModel = TimeSelectTableViewCellModel(timeSelectModels: timeSelectModels)
            cellModels.append(cellModel)
        }
    }
    
    @IBAction func tappedAddItem(sender: UIButton) {
        let foodItemViewController = FoodItemModalViewController()
        foodItemViewController.foodItemModalViewControllerDelegate = self
        presentViewController(foodItemViewController, animated: true, completion: nil)
    }
}

extension AddMealViewController: FoodItemModalViewControllerDelegate {
    public func didAddFoodItem(name: String, fat: Double, carbs: Double, protein: Double) {
        print(name)
    }
}

extension AddMealViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(TimeSelectTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? TimeSelectTableViewCell {
            let cellModel = cellModels[indexPath.row]
            cell.setup(cellModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellModel = cellModels[indexPath.row]
        return TimeSelectTableViewCell.size(tableView.width, viewModel: cellModel).height
    }
}