//
//  InviteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/05.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

// 카카오 공유하기 기능
class InviteVC: UIViewController {
    @IBOutlet weak var kakaoInviteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonSetting()
    }
}


extension InviteVC {
    func ButtonSetting(){
        kakaoInviteBtn.addTarget(self, action: #selector(touchInviteBtn), for: .touchUpInside)
    }
    
    @objc func touchInviteBtn(){
        let templeteId = "23118";
        
        KLKTalkLinkCenter.shared().sendCustom(withTemplateId: templeteId, templateArgs: nil, success: {(warningMsg, argumentMsg) in
            print("warning message : \(String(describing: warningMsg))")
            print("argument message : \(String(describing: argumentMsg))")
        }, failure: {(error) in
            print("error \(error)")
        })
    }
}
