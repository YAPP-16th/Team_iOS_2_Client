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
        // Location 타입 템플릿 오브젝트 생성
        let templete = KMTLocationTemplate.init { (KMTLocationTemplateBuilder) in
            // 컨텐츠
            KMTLocationTemplateBuilder.content = KMTContentObject.init(builderBlock: { (KMTContentBuilder) in
                KMTContentBuilder.title = "현창이의 공유 앨범" // 공유앨범 이름으로 변경해야 함
                KMTContentBuilder.desc = "90's 제작 과정을 담은 소중한 추억들" // 소갯말
                KMTContentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!
                KMTContentBuilder.link = KMTLinkObject.init(builderBlock: {(KMTLinkBuilder) in
                    KMTLinkBuilder.mobileWebURL = URL.init(string: "https://developers.kakao.com")
                })
            })
            
            // 버튼
            KMTLocationTemplateBuilder.addButton(KMTButtonObject(builderBlock: {(KMTButtonBuilder) in
                KMTButtonBuilder.title = "웹으로 보기"
                KMTButtonBuilder.link = KMTLinkObject(builderBlock: { (KMTLinkBuilder) in
                    KMTLinkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            
            KMTLocationTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (KMTButtonBuilder) in
                KMTButtonBuilder.title = "앱으로 열기"
                KMTButtonBuilder.link = KMTLinkObject(builderBlock: { (KMTLinkBuilder) in
                    KMTLinkBuilder.iosExecutionParams = "param1=value1&param2=value2" // url
                    //KMTlinkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                })
            }))
        }
        
        // 서버에서 콜백으로 받을 정보 작성
        /**
         let serverCallbackArgs = ["user_id": "abcd",
         "product_id": "1234"]
         */
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: templete, success: { (warningMsg, argumentMsg) in
            // 성공
            print("warning message : \(String(describing: warningMsg))")
            print("argument message : \(String(describing: argumentMsg))")
        }, failure: { (error) in
            // 실패
            print("error \(error)")
        })
    }
}
