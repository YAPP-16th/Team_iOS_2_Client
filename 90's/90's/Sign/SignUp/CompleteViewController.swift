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
    var isSocial:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 8.0
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLoginVC(_ sender: Any) {
        if let social = isSocial {
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = mainSB.instantiateViewController(withIdentifier: "TabBarController")
            navigationController?.pushViewController(tabBarVC, animated: true)
        }else {
            let signInSB = UIStoryboard(name: "SignIn", bundle: nil)
            let loginVC = signInSB.instantiateViewController(identifier: "LoginMainViewController") as! LoginMainViewController
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
}
    
    
}
