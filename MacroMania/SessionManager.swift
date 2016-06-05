//
//  SessionManager.swift
//  MacroMania
//
//  Created by Ken Yu on 6/5/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public class SessionManagerKeys {
    static let kToken = "TOKEN"
    static let kUserId = "USER_ID"
}

public class SessionManager {
    // Static
    static let sharedInstance = SessionManager()
    
    // Public
    public var token: String? = nil
    public var userId: Int? = nil
    
    private init() {
    }
    
    public func isLoggedIn() -> Bool {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(SessionManagerKeys.kToken) {
            self.token = token
            self.userId = NSUserDefaults.standardUserDefaults().integerForKey(SessionManagerKeys.kUserId)
            return true
        }
        return false
    }
    
    public func createSession(token: String, userId: Int) {
        // Store token
        self.token = token
        self.userId = userId
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: SessionManagerKeys.kToken)
        NSUserDefaults.standardUserDefaults().setInteger(userId, forKey: SessionManagerKeys.kUserId)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Get log in auth header
    public func getLogInAuthHeader(email: String, password: String) -> [String: String] {
        let userPasswordString = "\(email):\(password)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
        let authString = "Basic \(base64EncodedCredential)"
        let authHeader = ["Authorization" : authString]
        return authHeader
    }
    
    // Log in
    public func login(email: String, password: String, completion: ((object: ResponseObject) -> Void)?) {
        let authHeader = getLogInAuthHeader(email, password: password)
        
        // Fire token request to get token
        NetworkManager.sharedInstance.getRequest("/token", headers: authHeader) { [weak self] (response) -> Void in
            guard let strongSelf = self else { return }
            
            var responseToken: String? = nil
            var message: String
            var success: Bool = false
            
            switch response.result {
            case .Success(let JSON):
                if let token = JSON["token"] as? String, user = JSON["user"] as? [String: AnyObject], userId = user["id"] as? Int {
                    success = true
                    message = "Successfully authenticated. Token = \(token)"
                    responseToken = token
                    strongSelf.createSession(token, userId: userId)
                } else {
                    message = "Unable to authenticate."
                }
            default:
                message = "Unable to authenticate."
            }
            
            let responseObject = ResponseObject(object: responseToken, success: success, message: message)
            completion?(object: responseObject)
        }
    }
    
    // Log out
    public func logout(completion: (() -> Void)?) {
        destroySession()
        completion?()
    }
    
    public func destroySession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SessionManagerKeys.kToken)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SessionManagerKeys.kUserId)
        SessionManager.sharedInstance.token = nil
        SessionManager.sharedInstance.userId = nil
    }
}