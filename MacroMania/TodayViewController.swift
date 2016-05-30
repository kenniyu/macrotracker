//
//  TodayViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class TodayViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
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
        title = "Today"
        
        setupNavBar()
        setupTableView()
        
        updateCellModels()
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        createAddButton()
    }
    
    private func createDate(hour: Int = 0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = 5
        components.day = 30
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
    
    private func generateRandomFoodItems() -> [FoodItem] {
        let foodItem1 = FoodItem(name: "Chicken Breast", fat: 1, carbs: 0, protein: 25)
        let foodItem2 = FoodItem(name: "Oatmeal", fat: 3.5, carbs: 30, protein: 5)
        let foodItem3 = FoodItem(name: "Olive Oil", fat: 9, carbs: 0, protein: 0)
        return [foodItem1, foodItem2, foodItem3]
    }
    
    private func updateCellModels() {
        cellModels = []
        for index in 0..<7 {
            let cellModel = TimeMealTableViewCellModel(mealDate: createDate(6 + index * 2), meal: Meal(foodItems: generateRandomFoodItems()))
            if index > 0 {
                let prevCellModel = cellModels[index - 1]
                prevCellModel.nextMealDate = cellModel.mealDate
            }
            cellModels.append(cellModel)
        }
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.backgroundColor = UIColor.clearColor()
        registerCells()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    private func registerCells() {
//        tableView.registerClass(BaseTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: BaseTableViewHeaderFooterView.kReuseIdentifier)
        tableView.registerNib(TimeMealTableViewCell.nib, forCellReuseIdentifier: TimeMealTableViewCell.reuseId)
    }
    
    public override func add() {
        <#code#>
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