//
//  CompletePassViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation


class CompletePassViewController: UIViewController {
    @IBOutlet weak var passLabel:UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    var pass:String!
    
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
        let startIndex = pass.index(pass.startIndex, offsetBy: 2)
        let endIndex = pass.endIndex
        let maskingPass = pass.replacingOccurrences(of: pass, with: "*", range: startIndex..<endIndex)
        passLabel.text = maskingPass
    }
    
}
