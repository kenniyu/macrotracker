//
//  ResponseObject.swift
//  Habits
//
//  Created by Ken Yu on 3/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public class ResponseObject {
    var success: Bool
    var message: String
    var object: AnyObject?
    
    public init(object: AnyObject?, success: Bool, message: String) {
        self.success = success
        self.message = message
        self.object = object
    }
}