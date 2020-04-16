//
//  StickerLayout.swift
//  90's
//
//  Created by 성다연 on 2020/04/17.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class StickerLayout: UIView {
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBAction func turnBtn(_ sender: UIButton) {
    }
}
