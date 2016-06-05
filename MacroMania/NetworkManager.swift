//
//  NetworkManager.swift
//  Habits
//
//  Created by Ken Yu on 3/19/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public class NetworkResponseKeys {
    static let kStatus = "okay"
    static let kObjectCount = "objectCount"
    static let kObject = "object"
    static let kMessage = "message"
    static let kMessageCode = "code"
}

public class NetworkBaseUrls {
    static let kCore = "/stellar-core/rs"
    static let kPayment = "/payments/rest"
}

public class Environment {
    static let kLocal = "http://localhost:3000"
    static let kDev = "https://0ec37689.ngrok.io"
}

public class NetworkManager {
    static let kAuthHeaderKey = "Authorization"
    static let sharedInstance = NetworkManager()
    
    public var baseUrl: String!
    
    private init() {
        //        baseCoreUrl = "\(Environment.kDev)\(NetworkBaseUrls.kCore)"
        //        basePaymentUrl = "\(Environment.kDev)\(NetworkBaseUrls.kPayment)"
        baseUrl = "\(Environment.kDev)"
        
        #if DEBUG
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                baseUrl = "\(Environment.kLocal)"
            #endif
        #endif
    }
    
    public func postFormRequest(path: String, params: [String: AnyObject]? = nil, additionalHeaders: [String: String]? = nil, useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        var formHeader = ["Content-Type": "application/x-www-form-urlencoded"]
        formHeader.add(getRequestHeader())
        if let additionalHeaders = additionalHeaders {
            formHeader.add(additionalHeaders)
        }
        
        Alamofire.request(.POST, "\(baseUrl)\(path)", parameters: params, headers: formHeader).responseJSON { (response) -> Void in
            completion?(response)
        }
    }
    
    public func postRequest(path: String, params: [String: AnyObject]? = nil, includeHeaders: Bool = false, useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        Alamofire.request(.POST, "\(baseUrl)\(path)", parameters: params).responseJSON { response in
            completion?(response)
        }
    }
    
    public func postAuthRequest(path: String, params: [String: AnyObject]? = nil, headers: [String: String]? = nil, useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        var requestHeaders = getRequestHeader()
        if let headers = headers {
            requestHeaders.add(headers)
        }
        
        Alamofire.request(.POST, "\(baseUrl)\(path)", encoding: .JSON, parameters: params, headers: requestHeaders).responseJSON { response in
            completion?(response)
        }
    }
    
    
    public func deleteRequest(path: String, params: [String: AnyObject]? = nil, headers: [String: String], useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        let requestHeaders = getRequestHeader()
        Alamofire.request(.DELETE, "\(baseUrl)\(path)", parameters: params, encoding: .JSON, headers: requestHeaders).responseJSON { response in
            completion?(response)
        }
    }
    
    
    public func getRequest(path: String, params: [String: AnyObject]? = nil, headers: [String: String] = [:], useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        var requestHeaders = headers
        requestHeaders.add(getRequestHeader())
        let url = "\(baseUrl)\(path)"
        Alamofire.request(.GET, url, parameters: params, headers: requestHeaders).responseJSON { (response) -> Void in
            completion?(response)
        }
    }
    
    public func patchRequest(path: String, params: [String: AnyObject]? = nil, headers: [String: String] = [:], useDefaultBaseUrl: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        let fullUrl = "\(baseUrl)\(path)"
        Alamofire.request(.PATCH, fullUrl, parameters: params, encoding: .JSON, headers: getRequestHeader()).responseJSON { (response) -> Void in
            completion?(response)
        }
    }
    
    public func putRequest(path: String, params: [String: AnyObject]? = nil, var headers: [String: String] = [:], useDefaultBaseUrl: Bool = true, form: Bool = false, includeHeaders: Bool = true, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        if form {
            headers.add(["Content-Type": "application/x-www-form-urlencoded"])
        }
        
        if includeHeaders {
            headers.add(getRequestHeader())
        }
        
        Alamofire.request(.PUT, "\(baseUrl)\(path)", parameters: params, headers: headers).responseJSON { (response) -> Void in
            completion?(response)
        }
    }
    
    private func getRequestHeader() -> [String: String] {
        if let token = SessionManager.sharedInstance.token {
            return ["Authorization": "Token token=\(token)"]
        }
        return [:]
    }
}