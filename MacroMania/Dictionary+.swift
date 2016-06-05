//
//  Dictionary+.swift
//  Habits
//
//  Created by Ken Yu on 3/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func add(other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}