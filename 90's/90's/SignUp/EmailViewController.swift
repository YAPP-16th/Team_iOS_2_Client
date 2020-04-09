//
//  EmailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailValidationLabel.isHidden = true
        tfEmail.delegate = self
        tfEmail.becomeFirstResponder()
           
           NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfEmail, queue: .main, using : {
               _ in
               let str = self.tfEmail.text!.trimmingCharacters(in: .whitespaces)
               
               if(str != ""){
                   self.selectorImageView.backgroundColor = UIColor.black
                   self.nextBtn.backgroundColor = UIColor.black
                   self.nextBtn.isEnabled = true
               }else {
                   self.selectorImageView.backgroundColor = UIColor.gray
                   self.nextBtn.backgroundColor = UIColor.gray
                   self.nextBtn.isEnabled = false
               }
               
           })
    }
    
    @IBAction func clickNextBtn(_ sender: Any) {
        let email = tfEmail.text!
    
        //string extension을 통해 정규식 검증
        if(email.validateEmail()){
            emailValidationLabel.isHidden = true
            let passwordVC = storyboard?.instantiateViewController(identifier: "PasswordViewController") as! PasswordViewController
            navigationController?.pushViewController(passwordVC, animated: true)
        }else {
            emailValidationLabel.isHidden = false
        }
    }
    
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmail.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfEmail.resignFirstResponder()
        return true
    }
}


