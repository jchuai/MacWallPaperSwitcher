//
//  KeyValueObject.swift
//  BingWallpaper
//
//  Created by Junna on 11/27/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

class KeyValueObject: NSObject {
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

class XMLBasedObject: KeyValueObject, NSXMLParserDelegate {
    internal var parserTag : Int = -1
    func parse(parser: FlickrXMLParser) {
        parserTag = parser.tag
        parser.delegate = self
        parser.parse()
    }
    
    private var tempValue: String = ""
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.setValues(attributeDict)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        tempValue += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.setValue(tempValue, forKey: elementName)
        tempValue = ""
    }
}

class FlickrXMLParser {
    var tag     : Int
    var parser  : NSXMLParser
    
    weak var delegate : NSXMLParserDelegate? {
        didSet {
            parser.delegate = delegate
        }
    }
    
    init(parser: NSXMLParser, tag: Int) {
        self.parser = parser
        self.tag    = tag
    }
    
    func parse() {
        parser.parse()
    }
}




