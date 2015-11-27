//
//  FlickrViewModel.swift
//  BingWallpaper
//
//  Created by Junna on 11/27/15.
//  Copyright © 2015 Junna. All rights reserved.
//

import Foundation
import Darwin

let BaseApiURL  : String = "https://api.flickr.com/services/rest"
let AppKey      : String = "c6951490319c13c8c1f60d80453309a2"
let AppSecret   : String = "94143744252ca6c8"
let Userid      : String = "124075276@N04"

enum RequestType: Int {
    case People, PhotoInfo, Photos
}

private enum FlickrApiMethod: String {
    case People    = "flickr.people.getInfo"
    case Photos    = "flickr.people.getPhotos"
    case PhotoInfo = "flickr.photos.getInfo"

}

class FlickrViewModel {
    private var photographer    : FlickrPeopleInfo
    private var wallPaperInfo   : FlickrPhotoInfo
    init() {
        photographer    = FlickrPeopleInfo()
        wallPaperInfo   = FlickrPhotoInfo()
    }
    
    func loadViewModel() {
        fetchPeopleInfo()
    }
    
    func wallPaperURL() -> NSURL? {
        if wallPaperInfo.downloaded {
            return NSURL(fileURLWithPath: wallPaperInfo.localPath)
        } else {
            // If there is no new photo, fetch new photos from server. And search local folder, randomly pick one.
            if let id = photographer.photos.popFirst() {
                fetchPhotoInfo(withId: id)
            }
            do {
                let fm = NSFileManager.defaultManager()
                let localPhotos = try fm.contentsOfDirectoryAtPath(Utils.imagesDictionary() as String)
                if !localPhotos.isEmpty {
                    let index = Int(NSTimeIntervalSince1970) % localPhotos.count
                    let path = Utils.imagesDictionary().stringByAppendingPathComponent(localPhotos[index])
                    return NSURL(fileURLWithPath: path)
                }
                
            } catch let error as NSError {
                print("Get local photos error: \(error)")
            }
            return nil
        }
    }
    
    private func fetchPeopleInfo() {
        let request = FlickrHttpRequest(type: .XML)
        request.url = BaseApiURL
        request.param = ["method": FlickrApiMethod.People.rawValue, "api_key": AppKey, "user_id": Userid]
        request.delegate = self
        request.tag = RequestType.People.rawValue
        request.start()
    }
    private func fetchPeopleInfoSuccess() {
        fetchPhotos()
    }
    
    private var page: Int = 1
    private var readyToFetchPhotoInfo: Bool = false
    private func fetchPhotos() {
        let request = FlickrHttpRequest(type: .XML)
        request.url = BaseApiURL
        request.param = ["method": "flickr.people.getPhotos", "api_key": AppKey, "user_id": Userid, "per_page": 8, "page": page]
        request.delegate = self
        request.tag = RequestType.Photos.rawValue
        request.start()
    }
    private func fetchPhotosSuccess() {
        page++
        if page > photographer.totalPages {
            print("All photos from photographer \(photographer.username) downloaded!\n Maybe try other Photographer :) ")
            page = 1
        }
        readyToFetchPhotoInfo = true
    }
    
    private var readyToDownloadNewPhoto: Bool = false
    private func fetchPhotoInfo(withId id: String) {
        let request = FlickrHttpRequest(type: .XML)
        request.url = BaseApiURL
        request.param = ["method": "flickr.photos.getInfo", "api_key": AppKey, "photo_id": id]
        request.delegate = self
        request.tag = RequestType.PhotoInfo.rawValue
        request.start()
    }
    private func fetchPhotoInfoSuccess() {
        wallPaperInfo.download()
    }
    
    
}

extension FlickrViewModel: FlickrHttpRequestDelegate {
    func onSuccess(request: FlickrHttpRequest, responseData: AnyObject!) {
        if let xmlParser = responseData as? NSXMLParser {
            if let type = RequestType(rawValue: request.tag) {
                let parser = FlickrXMLParser(parser: xmlParser, tag: request.tag)
                switch type {
                case .People:
                    photographer.parse(parser)
                    fetchPeopleInfoSuccess()
                case .Photos:
                    photographer.parse(parser)
                    fetchPhotosSuccess()
                case .PhotoInfo:
                    wallPaperInfo.parse(parser)
                    wallPaperInfo.download()
                default:
                    break
                }
            }
        }
    }
    
    func onFailure(request: FlickrHttpRequest, error: NSError!) {
        
    }
}
