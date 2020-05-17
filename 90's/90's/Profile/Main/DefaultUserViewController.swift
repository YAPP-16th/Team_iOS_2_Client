//
//  DefaultUserViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class DefaultUserViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    var titleStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleStr
        loginBtn.layer.cornerRadius = 8.0
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchSignIn()
    }
    
    
    
}
