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
    @IBOutlet weak var inviteLabel: UILabel!
    @IBAction func cancleBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension InviteVC {
    func defaultSetting(){
        kakaoInviteBtn.addTarget(self, action: #selector(touchInviteBtn), for: .touchUpInside)
        inviteLabel.text = "친구를 초대하고\n함께 추억을 쌓아보세요!"
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
