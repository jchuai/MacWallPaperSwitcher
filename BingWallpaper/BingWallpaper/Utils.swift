//
//  Utils.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

class Utils {
    class func imagesDictionary() -> NSString {
        let fm = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let imagePath = NSString(string: paths[0]).stringByAppendingPathComponent("Images")
        fm.createDirectoryIfNotExist(imagePath)
        return imagePath
    }
}

extension NSFileManager {
    
    func createDirectoryIfNotExist(path: String) -> Bool {
        
        var isDirectory : ObjCBool = false
        let fileExist = fileExistsAtPath(path, isDirectory: &isDirectory)
        
        if !fileExist || !isDirectory {
            
            do {
                // file exist but not directory, remove the file first
                if fileExist {
                    try removeItemAtPath(path)
                }
                
                // create directory
                try createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError{
                
                print("error: \(error.domain)")
                return false
            }
        }
        
        return true
    }
}