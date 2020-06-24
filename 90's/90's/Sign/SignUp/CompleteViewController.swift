//
//  CompleteViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    var isSocial:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 8.0
        titleLabel.textLineSpacing(firstText: "축하합니다!", secondText: "90's의 회원이 되었습니다")
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLoginVC(_ sender: Any) {
        //카카오 회원가입일 시 바로 탭 화면으로 이동함
        if(isSocial) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchTab()
        }else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchSignIn()
        }
        
}
    
    
}
