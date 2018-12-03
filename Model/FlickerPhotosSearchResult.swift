//
//  FlickerPhotosSearchResult.swift
//  UDemo
//
//  Created by Umang Chouhan on 12/3/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import Foundation
import UIKit

class FlickerPhotosSearchResult {
    var currentPage: Int
    var totalNumberOfPages: Int
    var itemPerPage: Int
    var totalItems: Int
    var photos: [Photo]
    
    init?(json: [String: Any]) {
        guard let page = json["page"] as? Int, let pages = json["pages"] as? Int, let perpage = json["perpage"] as? Int, let totalStr = json["total"] as? String, let total = Int(totalStr), let photos = json["photo"] as? [[String: Any]] else {
            return nil
        }
        self.currentPage = page
        self.totalNumberOfPages = pages
        self.itemPerPage = perpage
        self.totalItems = total
        self.photos = photos.photos()
    }
}

class Photo {
    var id: String
    var farm: Int
    var server: String
    var secret: String
    var image: UIImage?
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String, let farm = json["farm"] as? Int, let server = json["server"] as? String, let secret = json["secret"] as? String else {
            return nil
        }
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    func url() -> String {
        return "http://farm\(self.farm).static.flickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
    }
}

extension Sequence where Iterator.Element == [String: Any] {
    
    func photos() -> [Photo] {
        var returnValue = [Photo]()
        self.forEach { (value) in
            if let photo = Photo.init(json: value) {
                returnValue.append(photo)
            }
        }
        return returnValue
    }
}

