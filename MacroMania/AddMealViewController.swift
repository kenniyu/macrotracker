//
//  AddMealViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class AddMealViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroStateView: UIView!
    @IBOutlet weak var zeroStateLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    public static let kNibName = "AddMealViewController"
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: AddMealViewController.kNibName, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Meal"
        setupNavBar()
        setupTableView()
        setupZeroStateView()
        
        toggleZeroStateView(true)
    }
    
    public override func setupStyles() {
        zeroStateLabel.font = Styles.Fonts.ThinLarge
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
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    private func setupNavBar() {
        let doneButton = createDoneButton()
        addRightBarButtons([doneButton])
        addCloseButton()
    }
    
    public override func done() {
        dismissViewControllerAnimated(true, completion: nil)
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
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0
    }
}