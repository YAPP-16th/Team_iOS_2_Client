//
//  FindEmailErrViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class FindEmailErrViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var findAgainBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reFindEmail(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }
    
    func setUI(){
        findAgainBtn.layer.cornerRadius = 8.0
        loginBtn.layer.cornerRadius = 8.0
        titleLabel.textLineSpacing(firstText: "해당 번호로 등록된", secondText: "이메일이 없습니다")
    }
    
}
