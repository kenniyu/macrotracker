//
//  Meal.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public class Meal {
    var foodItems: [FoodItem]
    
    public init(foodItems: [FoodItem]) {
        self.foodItems = foodItems
    }
}