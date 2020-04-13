//
//  AlbumCoverCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCell : UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subImageViewSetting(imageView: imageView, top: 0, left: 0, right: 0, bottom: 30)
    }
}

