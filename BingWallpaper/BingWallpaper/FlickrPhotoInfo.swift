//
//  FlickrPhotoInfo.swift
//  BingWallpaper
//
//  Created by Junna on 11/27/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

/*
1. demo: https://api.flickr.com/services/rest?method=flickr.photos.getInfo&api_key=c6951490319c13c8c1f60d80453309a2&photo_id=23248526365

<rsp stat="ok">
<photo id="23248526365" secret="9a786da73e" server="579" farm="1" dateuploaded="1448296057" isfavorite="0" license="0" safety_level="0" rotation="0" originalsecret="2fa13ae485" originalformat="jpg" views="2306" media="photo">
<owner nsid="124075276@N04" username="imhof.patrick" realname="imhof patrick" location="" iconserver="301" iconfarm="1" path_alias="imhof89"/>
<title>Blitzingen, Goms</title>
<description/>
<visibility ispublic="1" isfriend="0" isfamily="0"/>
<dates posted="1448296057" taken="2015-11-22 16:21:31" takengranularity="0" takenunknown="0" lastupdate="1448495540"/>
<editability cancomment="0" canaddmeta="0"/>
<publiceditability cancomment="1" canaddmeta="0"/>
<usage candownload="1" canblog="0" canprint="0" canshare="1"/>
<comments>15</comments>
<notes/>
<people haspeople="0"/>
<tags>
<tag id="124043137-23248526365-1168533" author="124075276@N04" authorname="imhof.patrick" raw="Goms" machine_tag="0">goms</tag>
...
</tags>
<urls>
<url type="photopage">https://www.flickr.com/photos/imhof89/23248526365/</url>
</urls>
</photo>
</rsp>

2. Photo URL formate https://www.flickr.com/services/api/misc.urls.html
https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
or
https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
or
https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)

*/

class FlickrPhotoInfo: XMLBasedObject {
    var id              : String = ""
    var secret          : String = ""
    var server          : String = ""
    var farm            : String = ""
    var originalsecret  : String = ""
    var originalformat  : String = ""
    var title           : String = ""
    var downloaded      : Bool   = false
    
    var localPath: String {
        get {
            return Utils.imagesDictionary().stringByAppendingPathComponent("\(id).\(originalformat)")
        }
    }
    
    var originPhotoUrl: String {
        get {
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(originalsecret)_o.\(originalformat)"
        }
    }
    
    // Notice: not all the specifications are provided. The original photo is recommended.
    func photoUrlWithSizeOption(option: PhotoSizeOption) -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(option.rawValue).jpg"
    }
    
    func download() {
        if NSFileManager.defaultManager().fileExistsAtPath(localPath) {
            downloaded = true
            print("Image: \(localPath) already exists!!")
            return
        }
        if let url = NSURL(string: originPhotoUrl) {
            let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configure, delegate: self, delegateQueue: nil)
            let task = session.downloadTaskWithURL(url)
            task.resume()
        }
    }
    
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "photo" {
            self.setValues(attributeDict)
        }
    }
    
    enum PhotoSizeOption: Character {
        /*
        s	small square 75x75
        q	large square 150x150
        t	thumbnail, 100 on longest side
        m	small, 240 on longest side
        n	small, 320 on longest side
        -	medium, 500 on longest side
        z	medium 640, 640 on longest side
        c	medium 800, 800 on longest side†
        b	large, 1024 on longest side*
        h	large 1600, 1600 on longest side†
        k	large 2048, 2048 on longest side†
        */
        case small = "s"
        case large = "q"
        case thumbnail = "t"
        case small240 = "m"
        case small320 = "n"
        case medium500 = "-"
        case medium640 = "z"
        case medium800 = "c"
        case large1024 = "b"
        case large1600 = "h"
        case large2048 = "k"
    }
}

extension FlickrPhotoInfo: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: NSURL(fileURLWithPath: localPath))
            downloaded = true
        } catch let error as NSError {
            print("BingWallPaper: copy error: \(error)")
        }
    }
}























