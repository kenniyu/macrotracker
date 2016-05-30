//
//  HomeViewController.swift
//  MacroMania
//
//  Created by Ken Yu on 5/7/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class HomeViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var caloriesMeterView: MeterView!
    @IBOutlet weak var fatMeterView: MeterView!
    @IBOutlet weak var carbsMeterView: MeterView!
    @IBOutlet weak var proteinMeterView: MeterView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var radialDotsTimeLapseView: RadialDotsTimeLapseView!
    @IBOutlet weak var mainCaloriesView: UIView!
    @IBOutlet weak var numCaloriesLabel: UILabel!
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var radialGradientView: RadialGradientView!
    @IBOutlet weak var gridBackgroundView: GridBackgroundView!
    
    
    public static let kNibName = "HomeViewController"
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: HomeViewController.kNibName, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMeters()
        setupMainCaloriesView()
        
        setupButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.appBecameActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    public override func viewDidLayoutSubviews() {
        setupGridBackgroundView()
    }
    
    public func setupGridBackgroundView() {
        gridBackgroundView.setup()
    }
    
    public func appBecameActive() {
        print("Hello")
        setupRingView()
        radialDotsTimeLapseView.startRotate(60)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupRadialDotsTimeLapseView()
        setupRingView()
    }
    
    private func setupButton() {
        
        addButton.tintColor = Styles.Colors.AppSilver
        cancelButton.tintColor = Styles.Colors.AppSilver
    }
    
    private func setupRadialDotsTimeLapseView() {
        radialDotsTimeLapseView.setup()
    }
    
    private func setupMainCaloriesView() {
        numCaloriesLabel.font = Styles.Fonts.ThinXXXXLarge
        numCaloriesLabel.textColor = Styles.Colors.AppSilver
        caloriesTextLabel.font = Styles.Fonts.MediumLarge
        caloriesTextLabel.textColor = Styles.Colors.AppSilver
    }
    
    
    
    private func setupMeters() {
        let (totalCalories, fatGrams, carbsGrams, proteinGrams) = getMeterMaxValues()
        
        caloriesMeterView.setup("Calories", current: 0, max: totalCalories)
        fatMeterView.setup("Fat", current: 0, max: fatGrams)
        carbsMeterView.setup("Carbs", current: 0, max: carbsGrams)
        proteinMeterView.setup("Protein", current: 0, max: proteinGrams)
        
        finalizeMeters()
    }

    private func getMeterMaxValues() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let fatGrams: CGFloat = 80
        let carbsGrams: CGFloat = 350
        let proteinGrams: CGFloat = 350
        let totalCalories = fatGrams * 9 + carbsGrams * 4 + proteinGrams * 4
        
        return (totalCalories, fatGrams, carbsGrams, proteinGrams)
    }
    
    private func getMeterCurrentValues() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let fatGrams: CGFloat = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kFatGrams))
        let carbsGrams: CGFloat = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kCarbsGrams))
        let proteinGrams: CGFloat = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey(MacroKeys.kProteinGrams))
        let totalCalories = fatGrams * 9 + carbsGrams * 4 + proteinGrams * 4
        
        return (totalCalories, fatGrams, carbsGrams, proteinGrams)
    }
    
    private func finalizeMeters() {
        let (maxCalories, maxFat, maxCarbs, maxProtein) = getMeterCurrentValues()
        delay(0.2, closure: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fatMeterView.meterCurrent = maxFat
            strongSelf.carbsMeterView.meterCurrent = maxCarbs
            strongSelf.proteinMeterView.meterCurrent = maxProtein
            strongSelf.caloriesMeterView.meterCurrent = maxCalories
            
            strongSelf.updateViews()
        })
    }
    
    public func storeMacros() {
        NSUserDefaults.standardUserDefaults().setObject(fatMeterView.meterCurrent, forKey: MacroKeys.kFatGrams)
        NSUserDefaults.standardUserDefaults().setObject(carbsMeterView.meterCurrent, forKey: MacroKeys.kCarbsGrams)
        NSUserDefaults.standardUserDefaults().setObject(proteinMeterView.meterCurrent, forKey: MacroKeys.kProteinGrams)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func addMacros(sender: UIButton) {
        let addMacrosViewController = AddMacrosViewController()
        addMacrosViewController.addMacrosViewControllerDelegate = self
        let navigationController = BaseNavigationController(rootViewController: addMacrosViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func resetMacros(sender: UIButton) {
        fatMeterView.meterCurrent = 0
        carbsMeterView.meterCurrent = 0
        proteinMeterView.meterCurrent = 0
        caloriesMeterView.meterCurrent = 0
        updateViews()
    }
    
    public func updateViews() {
        updateMainCaloriesView()
        storeMacros()
        
        let fatPct = fatMeterView.meterCurrent / fatMeterView.meterMax
        let carbsPct = carbsMeterView.meterCurrent / carbsMeterView.meterMax
        let proteinPct = proteinMeterView.meterCurrent / proteinMeterView.meterMax
        
        radialDotsTimeLapseView.setupMacroRings([fatPct, carbsPct, proteinPct])
    }
    
    public func updateMainCaloriesView() {
        numCaloriesLabel.text = "\(Int(caloriesMeterView.meterCurrent))"
        caloriesTextLabel.text = "Calories".uppercaseString
    }
    
    public func setupRingView() {
        let gradientRingLayer = RingGradientLayer(bounds: CGRectMake(0, 0, ringView.width, ringView.height), position:CGPointMake(ringView.width/2, ringView.height/2), fromColor: Styles.Colors.White, toColor: Styles.Colors.AppPurple.colorWithAlphaComponent(0.1), linewidth:2.0, toValue: 0)
        ringView.layer.addSublayer(gradientRingLayer)
        
        gradientRingLayer.animateCircleTo(1, fromValue: 0, toValue: 0.999)
        animateRingView()
    }
    
    private func animateRingView() {
        let duration = 3.0
        ringView.rotate("ringAnimation", duration: duration, direction: 0)
    }
}

extension HomeViewController: AddMacrosViewControllerDelegate {
    public func didAddMacros(fat: Double, carbs: Double, protein: Double) {
        delay(0.0, closure: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fatMeterView.meterCurrent += CGFloat(fat)
            strongSelf.carbsMeterView.meterCurrent += CGFloat(carbs)
            strongSelf.proteinMeterView.meterCurrent += CGFloat(protein)
            strongSelf.caloriesMeterView.meterCurrent += CGFloat(fat * 9 + carbs * 4 + protein * 4)
            
            strongSelf.updateViews()
        })
    }
}