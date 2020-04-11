//
//  AlbumCoverCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subImageViewSetting(imageView: photoImageView, top: 10, left: 8, right: -8, bottom: -40)
        photoImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        print("contentview size : \(self.contentView.frame.size), imageview : \(self.photoImageView.frame.size)")
    }
}

