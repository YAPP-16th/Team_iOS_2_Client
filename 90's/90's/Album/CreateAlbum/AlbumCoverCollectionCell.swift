//
//  AlbumCoverCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCoverCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subImageViewSetting(imageView: imageView, top: 0, left: 0, right: 0, bottom: 0)
        subImageViewSetting(imageView: selectImageView, top: 0, left: 0, right: 0, bottom: 0)
    }
}
