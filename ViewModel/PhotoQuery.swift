//
//  PhotoQuery.swift
//  UDemo
//
//  Created by Umang Chouhan on 12/3/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import Foundation
import UIKit

class PhotoQuery: NSObject, SearchItem {
    var page: Int
    var totalPhotos = Int.max
    var photos = [Photo]()
    let operationQueue = OperationQueue.init()
    
    var imageDownloadingTasks = [IndexPath: BlockOperation]()
    
    weak var  collectionView:UICollectionView? {
        didSet {
            self.registerCells()
            self.collectionView?.delegate = self
            self.collectionView?.dataSource = self
        }
    }
    
    func registerCells() {
        self.collectionView?.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
    
    var query: String {
        didSet {
            if oldValue != self.query {
                self.page = 1
            }
            self.addPhotos()
        }
    }
    
    func addPhotos() {
        self.search { (searchResult) in
            guard let result = searchResult else {
                return
            }
            if searchResult?.photos.count ?? 0 > 0 {
                var indexPaths = [IndexPath]()
                for i in self.photos.count...self.photos.count + result.photos.count - 1 {
                    indexPaths.append(IndexPath.init(item: i, section: 0))
                }
                self.photos.append(contentsOf: result.photos)
                self.page = result.currentPage
                self.totalPhotos = result.totalItems
                DispatchQueue.main.async {
                    self.collectionView?.insertItems(at: indexPaths)
                }
            }
        }
    }
    
    init(query: String) {
        self.page = 1
        self.query = query
        super.init()
        self.addPhotos()
    }
}

extension PhotoQuery: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 - 5, height: UIScreen.main.bounds.width/3 - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photos.count - 1 && self.photos.count < self.totalPhotos) {
            self.page = self.page + 1
            self.addPhotos()
        }
        if let image  = self.photos[indexPath.item].image {
            self.set(image: image, for: indexPath)
        }
        else {
            self.downloadImages(for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.imageDownloadingTasks[indexPath]?.cancel()
        self.imageDownloadingTasks[indexPath] = nil
    }
    
    func downloadImages(for indexPath:IndexPath) {
        if self.imageDownloadingTasks[indexPath] == nil {
            let photo = self.photos[indexPath.item]
            let urlStr = photo.url()
            guard let url = URL.init(string: urlStr) else {
                return
            }
            let blockOperation = BlockOperation.init()
            weak var weakBlockOperation = blockOperation
            weakBlockOperation?.addExecutionBlock {
                if weakBlockOperation?.isCancelled == false {
                    guard let data = try? Data.init(contentsOf: url), let image = UIImage.init(data: data)  else {
                        if let error = UIImage.init(named: "Error.png") {
                            self.set(image:error , for: indexPath)
                        }
                        return
                    }
                    
                    photo.image = image
                    self.set(image: image, for: indexPath)
                }
            }
            self.operationQueue.addOperation(blockOperation)
            self.imageDownloadingTasks[indexPath] = blockOperation
        }
    }
    
    func set(image: UIImage, for indexPath: IndexPath) {
        let photo = self.photos[indexPath.item]
        DispatchQueue.main.async {
            if let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
                cell.imageView.image = photo.image
            }
            self.imageDownloadingTasks[indexPath] = nil
        }
    }
}
