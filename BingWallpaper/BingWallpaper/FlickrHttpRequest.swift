//
//  FlickrHttpRequest.swift
//  BingWallpaper
//
//  Created by Junna on 11/27/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

protocol FlickrHttpRequestDelegate: class {
    func onSuccess(request: FlickrHttpRequest, responseData: AnyObject!)
    func onFailure(request: FlickrHttpRequest, error: NSError!)
}

enum HTTPRequestMethod: Int {
    case GET
}

enum HTTPResponseType: Int {
    case IMAGE, JSON, XML
}

class FlickrHttpRequest {

    weak var delegate: FlickrHttpRequestDelegate?
    var manager: AFHTTPRequestOperationManager
    var param: [String: AnyObject] = [:]
    var tag: Int = 0
    var url: String = ""
    var method: HTTPRequestMethod = .GET
    
    init(type: HTTPResponseType) {
        manager = AFHTTPRequestOperationManager()
        switch type {
        case .IMAGE:
            manager.responseSerializer = AFImageResponseSerializer()
        case .XML:
            manager.responseSerializer = AFXMLParserResponseSerializer()
        case .JSON:
            manager.responseSerializer = AFJSONResponseSerializer()
        }
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