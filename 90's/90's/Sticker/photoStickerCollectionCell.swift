//
//  photoStickerCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class photoStickerCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 40
    }
}


extension photoStickerCollectionCell {
    func hideimage(){
        checkImageView.isHidden = true
    }
    func showimage(){
        checkImageView.isHidden = false
    }
}
