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
}

extension photoStickerCollectionCell {
    func createSticker(image: UIImage) -> UIImageView{
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: super.contentView.frame.width/2 - 50,y: super.contentView.frame.height/2 - 50, width: 100, height: 100)
        imageView.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pan)
        
        return imageView
    }
    
    func toggleSetting(){
        if checkImageView.isHidden == true {
            checkImageView.isHidden = false
        }else {
            checkImageView.isHidden = true
        }
    }
}
