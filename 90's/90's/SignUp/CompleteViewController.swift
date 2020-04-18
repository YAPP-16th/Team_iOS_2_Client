//
//  CompleteViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 8.0

    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLoginVC(_ sender: Any) {
       //로그인 화면으로 가는 로직 구현
    }


}
