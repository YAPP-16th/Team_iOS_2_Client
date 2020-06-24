//
//  CompletePassViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class CompleteManageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var changeInfoLabel:UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var authenType:String!
    var email:String!
    var nickName:String!
    var pass:String!
    var telePhone:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func goLogin(_ sender: Any) {
        //로그인화면으로 rootView변경
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchSignIn()
    }
    
    func setUI(){
        loginBtn.layer.cornerRadius = 8.0
        titleLabel.text = authenType
        
        switch authenType {
        case "이메일 변경":
            changeInfoLabel.text = email
            nickNameLabel.text = "받아올 수 없어요.."
            subTitleLabel.textLineSpacing(firstText: "이메일이", secondText: "변경되었습니다!")
            break
        case "비밀번호 변경":
            changeInfoLabel.text = pass
            nickNameLabel.isHidden = true
            subTitleLabel.textLineSpacing(firstText: "비밀번호가", secondText: "변경되었습니다!")
            break
        case "전화번호 변경":
            changeInfoLabel.text = telePhone
            nickNameLabel.isHidden = true
            subTitleLabel.textLineSpacing(firstText: "전화번호가", secondText: "변경되었습니다!")
            break
        default:
            break
        }
        
    }
    
}
