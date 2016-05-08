//
//  AddMacrosViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/7/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public protocol AddMacrosViewControllerDelegate {
    func didAddMacros(fat: Double, carbs: Double, protein: Double)
}

public class AddMacrosViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Class
    public static let kNibName = "AddMacrosViewController"
    
    
    public var cellModels: [AddMacrosTableViewCellModel] = []
    public var addMacrosViewControllerDelegate: AddMacrosViewControllerDelegate?
    
    // Public
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: AddMacrosViewController.kNibName, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        setupTableView()
        
        createCellModels()
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        addCloseButton()
        
        let doneButton = createDoneButton()
        addRightBarButtons([doneButton])
        
        title = "Add Macros"
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        registerCells()
    }
    
    private func registerCells() {
        tableView.registerNib(AddMacrosTableViewCell.kNib, forCellReuseIdentifier: AddMacrosTableViewCell.kReuseIdentifier)
    }
    
    private func createCellModels() {
        cellModels = [
            AddMacrosTableViewCellModel(name: "Fat (g)", macro: 0),
            AddMacrosTableViewCellModel(name: "Carbs (g)", macro: 0),
            AddMacrosTableViewCellModel(name: "Protein (g)", macro: 0)
        ]
    }
    
    public override func done() {
        dismissViewControllerAnimated(true) { [weak self] in
            guard let strongSelf = self else { return }
            let fat = strongSelf.cellModels[0].macro ?? 0
            let carbs = strongSelf.cellModels[1].macro ?? 0
            let protein = strongSelf.cellModels[2].macro ?? 0
            
            strongSelf.addMacrosViewControllerDelegate?.didAddMacros(fat, carbs: carbs, protein: protein)
        }
    }
}

extension AddMacrosViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = cellModels[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(AddMacrosTableViewCell.kReuseIdentifier, forIndexPath: indexPath) as? AddMacrosTableViewCell {
            cell.setup(viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = cellModels[indexPath.row]
        return AddMacrosTableViewCell.size(tableView.width, viewModel: viewModel).height
    }
}

extension AddMacrosViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}