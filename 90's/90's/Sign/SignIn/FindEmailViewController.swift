//
//  FindEmailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class FindEmailViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //통신을 통해 찾아온 email, nickName 받아옴
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }
    
    func setUI(){
        loginBtn.layer.cornerRadius = 8.0
    }
    
}
