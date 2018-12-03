//
//  UDemoTests.swift
//  UDemoTests
//
//  Created by Umang Chouhan on 11/27/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import XCTest
@testable import UDemo

class UDemoTests: XCTestCase {
    var photoQuery: PhotoQuery?
    
    func searchResultString() -> String {
        return "{\"page\":1,\"pages\":1591,\"perpage\":100,\"total\":\"159017\",\"photo\":[{\"id\":\"44335632140\",\"owner\":\"158292164@N07\",\"secret\":\"87dcf7b96e\",\"server\":\"4852\",\"farm\":5,\"title\":\"№ 409\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}]}"
    }
    
    func demoSearchResult() -> [String: Any] {
        let data = searchResultString().data(using: .utf8)!
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
    
    func photoString() -> String {
    return "{\"id\":\"44335632140\",\"owner\":\"158292164@N07\",\"secret\":\"87dcf7b96e\",\"server\":\"4852\",\"farm\":5,\"title\":\"№ 409\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}"
    }
    
    func demoPhoto() -> [String: Any] {
        let data = photoString().data(using: .utf8)!
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
    
    override func setUp() {
        self.photoQuery = PhotoQuery.init(query: "test")
    }

    override func tearDown() {
        self.photoQuery = nil
    }

    func testNullability() {
        XCTAssertNotNil(self.photoQuery)
    }
    
    func testSearchURLForFirstPage() {
        let url = self.photoQuery?.url()
        XCTAssertEqual(url, "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3dc9935de0882b3ef69e4ce46cfb5025& format=json&nojsoncallback=1&safe_search=1&text=test&page=1")
    }
    
    func testSearchURLForSecondPage() {
        self.photoQuery?.page = 2
        let url = self.photoQuery?.url()
        XCTAssertEqual(url, "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3dc9935de0882b3ef69e4ce46cfb5025& format=json&nojsoncallback=1&safe_search=1&text=test&page=2")
    }
    
    func testPhotoValidity() {
        let photo = Photo.init(json:self.demoPhoto())
        XCTAssertNotNil(photo)
    }
    
    func testPhotoNullabilityForNoID() {
        var json = self.demoPhoto()
        json["id"] = nil
        let photo = Photo.init(json:json)
        XCTAssertNil(photo)
    }
    
    func testPhotoNullabilityForNoFarm() {
        var json = self.demoPhoto()
        json["farm"] = nil
        let photo = Photo.init(json:json)
        XCTAssertNil(photo)
    }
    
    func testPhotoNullabilityForNoServer() {
        var json = self.demoPhoto()
        json["server"] = nil
        let photo = Photo.init(json:json)
        XCTAssertNil(photo)
    }
    
    func testPhotoNullabilityForNoSecret() {
        var json = self.demoPhoto()
        json["secret"] = nil
        let photo = Photo.init(json:json)
        XCTAssertNil(photo)
    }
    
    func testSearchResultValidity() {
        let searchResult = FlickerPhotosSearchResult.init(json:self.demoSearchResult())
        XCTAssertNotNil(searchResult)
    }
    
    func testSearchResultValidityForNoCurrentPage() {
        var json = self.demoSearchResult()
        json["page"] = nil
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertNil(searchResult)
    }
    
    func testSearchResultValidityForNoTotalPage() {
        var json = self.demoSearchResult()
        json["pages"] = nil
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertNil(searchResult)
    }
    
    func testSearchResultValidityForNototalNumberOfPages() {
        var json = self.demoSearchResult()
        json["perpage"] = nil
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertNil(searchResult)
    }
    
    func testSearchResultValidityForNototalNumberOfItems() {
        var json = self.demoSearchResult()
        json["total"] = nil
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertNil(searchResult)
    }
    
    func testSearchResultPhotoCountForSingleEntry() {
        let json = self.demoSearchResult()
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertEqual(searchResult?.photos.count, 1)
    }
    
    func testSearchResultPhotoCountForMultipleEntry() {
        var json = self.demoSearchResult()
        var photoArr = [[String: Any]]()
        for _ in 0...4 {
            photoArr.append(self.demoPhoto())
        }
        json["photo"] = photoArr
        let searchResult = FlickerPhotosSearchResult.init(json:json)
        XCTAssertEqual(searchResult?.photos.count, 5)
    }

    func testPhotoImageURL() {
        let json = self.demoPhoto()
        let farm = json["farm"]!
        let server = json["server"]!
        let id = json["id"]!
        let secret = json["secret"]!
        
        let photo = Photo.init(json: json)
        XCTAssertEqual(photo?.url(), "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
