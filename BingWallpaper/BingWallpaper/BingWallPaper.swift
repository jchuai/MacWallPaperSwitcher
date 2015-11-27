//
//  BingWallPaper.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation
import AppKit

let ImageFoler : String = NSHomeDirectory()

class BingWallPaper: NSObject {
    var startdate       : String = ""
    var fullstartdate   : String = ""
    var enddate         : String = ""
    var url             : String = ""
    var urlbase         : String = ""
    var storyInfos      : [PhotoStoryInfo] = []
    var hsh             : String = "" // hash值
    
    var imageLoaded    : Bool   = false
    var httpUrl : String {
        get {
            if url.lowercaseString.hasPrefix("http:") {
                return url
            } else {
                return BingBaseURL + url
            }
        }
    }
    
    var fileUrl: NSURL {
        get {
            return NSURL(fileURLWithPath: Utils.imagesDictionary().stringByAppendingPathComponent(imageName), isDirectory: false)
        }
    }
    
    var imageName : String {
        get {
            return NSString(string: url).lastPathComponent
        }
    }
    
    func setValues(values: [String: AnyObject]) {
        for key in values.keys {
            if key == "msg" {
                if let msgs = values[key] as? [[String: AnyObject]] {
                    for msg in msgs {
                        let storyInfo = PhotoStoryInfo()
                        storyInfo.setValues(msg)
                        storyInfos.append(storyInfo)
                    }
                }
            } else {
                self.setValue(values[key], forKey: key)
            }
        }
        fetchImage()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    private func fetchImage() {
        if let path = fileUrl.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                imageLoaded = true
                print("Image: \(path) already exists!!")
                return
            }
        }
        if let url = NSURL(string: httpUrl) {
            let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configure, delegate: self, delegateQueue: nil)
            let task = session.downloadTaskWithURL(url)
            task.resume()
        }
    }
}
extension BingWallPaper: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: fileUrl)
            imageLoaded = true
        } catch let error as NSError {
            print("BingWallPaper: copy error: \(error)")
        }

    }
}

class PhotoStoryInfo: NSObject {
    var title       : String = ""
    var link        : String = ""
    var text        : String = ""
    func setValues(values: [String: AnyObject]) {
        for key in values.keys {
            if let value = values[key] {
                self.setValue(value, forKey: key)
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
