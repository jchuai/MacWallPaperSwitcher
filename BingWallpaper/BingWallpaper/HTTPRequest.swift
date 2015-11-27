//
//  HTTPRequest.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

protocol HTTPRequestDelegate: class {
    func onSuccess(request: HTTPRequest, responseData: AnyObject!)
    func onFailure(request: HTTPRequest, error: NSError!)
}

class HTTPRequest {
    enum HTTPRequestMethod: Int {
        case GET
    }
    weak var delegate: HTTPRequestDelegate?
    var manager: AFHTTPRequestOperationManager
    var param: [String: AnyObject] = [:]
    var tag: Int = 0
    var url: String = ""
    var method: HTTPRequestMethod = .GET
    init() {
        manager = AFHTTPRequestOperationManager()
    }
    
    func start() {
       switch method {
        case .GET:
            manager.GET(url, parameters: param, success: handleSuccess, failure: handleFailure)
        }
    }
    
    internal func handleSuccess(operation: AFHTTPRequestOperation!, responseData: AnyObject!) {
        delegate?.onSuccess(self, responseData: responseData)
    }
    
    internal func handleFailure(operation: AFHTTPRequestOperation!, error: NSError!) {
        delegate?.onFailure(self, error: error)
    }
}