//
//  FlickrPeopleInfo.swift
//  BingWallpaper
//
//  Created by Junna on 11/27/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation
/*
https://api.flickr.com/services/rest?method=flickr.people.getInfo&api_key=c6951490319c13c8c1f60d80453309a2&user_id=124075276@N04

<rsp stat="ok">
<person id="124075276@N04" nsid="124075276@N04" ispro="1" can_buy_pro="0" iconserver="301" iconfarm="1" path_alias="imhof89" has_stats="1" expire="0">
<username>imhof.patrick</username>
<realname>imhof patrick</realname>
<location/>
<description/>
<photosurl>https://www.flickr.com/photos/imhof89/</photosurl>
<profileurl>https://www.flickr.com/people/imhof89/</profileurl>
<mobileurl>https://m.flickr.com/photostream.gne?id=124043137</mobileurl>
<photos>
<firstdatetaken>2014-05-18 14:24:48</firstdatetaken>
<firstdate>1400953270</firstdate>
<count>288</count>
</photos>
</person>
</rsp>
*/

class FlickrPeopleInfo: XMLBasedObject {
    var id          : String            = ""
    var nsid        : String            = ""
    var username    : String            = ""
    var count       : Int               = 0
    var photos      : Set<String>       = []
    var pages       : String            = ""
    
    var totalPages: Int {
        get {
            return Int(pages) ?? 0
        }
    }
    
    private var tempPhotos: Set<String> = []
    func parserDidStartDocument(parser: NSXMLParser) {
        if parserTag == RequestType.Photos.rawValue {
            // 清空photos旧照片，准备存储新的photos
            photos.removeAll(keepCapacity: true)
        }
    }
    override func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "photo" {
            for key in attributeDict.keys {
                if key == "id" {
                    photos.insert(attributeDict[key]!)
                } else {
                    self.setValue(attributeDict[key]!, forKey: key)
                }
            }
        } else {
            super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        }
    }
}


