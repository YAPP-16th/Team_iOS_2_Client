//
//  photoFilterCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/01.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class photoFilterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
}

extension photoFilterCollectionCell {
    func hideimage(value : Bool){
        checkImageView.isHidden = value 
    }
}