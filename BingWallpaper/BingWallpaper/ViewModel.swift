//
//  ViewModel.swift
//  BingWallpaper
//
//  Created by Junna on 11/25/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation

let BingJsonURL: String = "http://www.bing.com/HPImageArchive.aspx"
let BingBaseURL: String = "http://www.bing.com"
class ViewModel: NSObject {
    var delegate : ViewController?
    var wallPaperURL: NSURL? {
        get {
           return wallPapers[currentIndex].fileUrl
        }
    }
    private var currentIndex: Int = 0
    private var initialized: Bool = false
    private var wallPapers: [BingWallPaper] = [] {
        didSet {
            viewModelDidLoad()
        }
    }
    
    private var idx: Int = 0 // 0：获取当天图片，n：获取n天前图片
    
    func loadViewModel() {
        fetchBingJson(idx, count: 8)
    }
    
    private func viewModelDidLoad() {
        if !initialized {
            initialized = true
            NSTimer.scheduledTimerWithTimeInterval(15 * 60, target: self, selector: "updateWallPaper", userInfo: nil, repeats: true)
            delegate?.reload()
        }
        idx++
    }
    
    @objc private func updateWallPaper() {
        delegate?.reload()
        currentIndex++
        if currentIndex == wallPapers.count - 1 {
            loadViewModel()
        }
    }
    
    
    private func fetchBingJson(idx: Int, count: Int) {
        let request = HTTPRequest()
        request.param = ["format": "js", "idx": idx, "n": count]
        request.url = BingJsonURL
        request.delegate = self
        request.tag = 1
        request.start()
    }

}

extension ViewModel: HTTPRequestDelegate {
    
    func onSuccess(request: HTTPRequest, responseData: AnyObject!) {
        switch request.tag {
        case 1: // 拉取bing Json格式data
            var newWallPapers: [BingWallPaper] = []
            if let json = responseData as? [String: AnyObject] {
                if let images = json["images"] as? [[String: AnyObject]] {
                    for image in images {
                        let wallPaper = BingWallPaper()
                        wallPaper.setValues(image)
                        newWallPapers.append(wallPaper)
                    }
                }
            }
            wallPapers.appendContentsOf(newWallPapers)
        default:
            break
        }
    }
    
    func onFailure(request: HTTPRequest, error: NSError!) {
    
    }
}

