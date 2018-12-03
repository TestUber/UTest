//
//  PhotoCollectionViewCell.swift
//  UDemo
//
//  Created by Umang Chouhan on 12/3/18.
//  Copyright © 2018 Umang. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
