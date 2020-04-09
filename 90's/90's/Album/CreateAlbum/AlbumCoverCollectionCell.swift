//
//  AlbumCoverCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCoverCollectionCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    
    // 셀 클릭시 체크 이미지를 addsubview로 올릴 예정 (hidden 대신 사용) -> cell에 extension으로 붙이기
}
