//
//  SNSViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/16.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class SNSViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    var titleStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleStr
        signUpBtn.layer.cornerRadius = 8.0
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickSignUpBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchSignUp()
    }
    

}
