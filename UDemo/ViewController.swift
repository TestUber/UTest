//
//  ViewController.swift
//  UDemo
//
//  Created by Umang Chouhan on 11/27/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var photoQuery: PhotoQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func search(text: String) {
        let photoQuery = PhotoQuery.init(query: text)
        photoQuery.collectionView = self.collectionView
        self.photoQuery = photoQuery
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.search(text: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
