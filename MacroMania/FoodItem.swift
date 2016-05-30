//
//  FoodItem.swift
//  MacroMania
//
//  Created by Ken Yu on 5/30/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public class FoodItem {
    var name: String
    var fat: Double
    var carbs: Double
    var protein: Double
    
    public init(name: String, fat: Double, carbs: Double, protein: Double) {
        self.name = name
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
}
