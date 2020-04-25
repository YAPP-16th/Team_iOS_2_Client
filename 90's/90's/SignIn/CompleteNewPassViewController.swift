//
//  CompleteNewPassViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class CompleteNewPassViewController: UIViewController {
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var newPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    @IBAction func goLogin(_ sender: Any) {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    func setUI(){
        loginBtn.layer.cornerRadius = 8.0
        //새로운 패스워드 넘김
        newPassLabel.text = newPass
    }
    
}
