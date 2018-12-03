//
//  SearchItem.swift
//  UDemo
//
//  Created by Umang Chouhan on 12/3/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import Foundation

fileprivate let apiKey = "3dc9935de0882b3ef69e4ce46cfb5025"

protocol SearchItem {
    var query: String {get set}
    var page: Int {get set}
}

extension SearchItem {
    func url() -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)& format=json&nojsoncallback=1&safe_search=1&text=\(self.query)&page=\(self.page)"
    }
    
    func search(completion: @escaping (FlickerPhotosSearchResult?)->Void) {
        FlickerService.search(item: self) { (result) in
            completion(result)
        }
    }
}


