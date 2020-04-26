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
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var resizeBtn: UIButton!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func sizeBtn(_ sender: UIButton) {
    }
    @IBAction func turnBtn(_ sender: UIButton) {
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setting()
    }
    
    func setting(){
        backImageView.image = UIImage(named: "stickerControlBox")!
        rotateBtn.imageView?.image = UIImage(named: "stickerControlRotate")!
        resizeBtn.imageView?.image = UIImage(named: "stickerControlSize")!
        self.isUserInteractionEnabled = true
    }
}

