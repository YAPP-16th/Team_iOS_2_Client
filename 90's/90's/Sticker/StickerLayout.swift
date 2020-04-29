//
//  StickerLayout.swift
//  90's
//
//  Created by 성다연 on 2020/04/17.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class StickerLayout: UIView {
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var rotateImageView: UIImageView!
    @IBOutlet weak var resizeImageView: UIImageView!
    @IBOutlet weak var cancleImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func loadFromZib(image : UIImage) -> StickerLayout {
        let view = Bundle.main.loadNibNamed("StickerLayout", owner: self, options: nil)?.first as! StickerLayout
        view.stickerImageView.image = image
        return view
    }
}

