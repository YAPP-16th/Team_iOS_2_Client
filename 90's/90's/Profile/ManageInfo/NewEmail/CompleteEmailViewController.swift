//
//  CompleteEmailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class CompleteEmailViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var email:String!
    
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
        emailLabel.text = email
        nickNameLabel.text = "없어요.."
        loginBtn.layer.cornerRadius = 8.0
        
    }
    
    
}
