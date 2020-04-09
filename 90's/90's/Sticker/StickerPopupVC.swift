//
//  StickerPopupVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/08.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class StickerPopupVC: UIViewController {
    @IBOutlet weak var touchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.touchView
        { self.dismiss(animated: true)}
    }
}
