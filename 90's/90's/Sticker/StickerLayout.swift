//
//  StickerLayout.swift
//  90's
//
//  Created by 성다연 on 2020/04/17.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class StickerLayout: UIView {
    @IBOutlet weak var stickerView: UIView!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBAction func sizeBtn(_ sender: UIButton) {
    }
    @IBAction func turnBtn(_ sender: UIButton) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
