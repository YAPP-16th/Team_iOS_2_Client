//
//  FindEmailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class FindEmailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    var email:String!
    var nickName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }
    
    func setUI(){
        loginBtn.layer.cornerRadius = 8.0
        emailLabel.text = email
        nickNameLabel.text = nickName
        titleLabel.textLineSpacing(firstText: "이메일을", secondText: "찾았습니다!")
    }
    
}
