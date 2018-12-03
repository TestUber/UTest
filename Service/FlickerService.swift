//
//  FlickerService.swift
//  UDemo
//
//  Created by Umang Chouhan on 12/3/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import Foundation

class FlickerService {
    
    static func search(item: SearchItem, completion: @escaping (FlickerPhotosSearchResult?)->Void ) {
        guard let urlString = item.url().addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let variantsData = data, let jsonData = try? JSONSerialization.jsonObject(with: variantsData, options: .allowFragments) as! [String: Any], let photos = jsonData["photos"] as? [String: Any] else {
                return
            }
            if let searchResult = FlickerPhotosSearchResult.init(json: photos) {
                completion(searchResult)
            }
        })
        task.resume()
    }
}
