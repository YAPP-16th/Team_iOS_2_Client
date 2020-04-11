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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subViewSetting()
    }
    // 셀 클릭시 체크 이미지를 addsubview로 올릴 예정 (hidden 대신 사용) -> cell에 extension으로 붙이기
}

extension AlbumCoverCollectionCell {
    func subViewSetting(){
        let screen = UIScreen.main.bounds
        
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 33).isActive = true
    }
}
