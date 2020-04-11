//
//  LoginMainViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class LoginMainViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var passValidationLabel: UILabel!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    
    let signSB = UIStoryboard.init(name: "SignUp", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPass.delegate = self
        tfEmail.delegate = self
        setUI()
        setTextFieldObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        //이메일 형식 검사 후 로그인 형식 맞지 않을 시 메시지 표시
        
        let email = tfEmail.text!
        if(!email.validateEmail()){
            emailValidationLabel.isHidden = false
            selectorImageView1.backgroundColor = UIColor.red
        }else{
            //로그인 통신
            //로그인 통신 후 로그인 실패시 메시지 표시
        }
        
    }
    
    @IBAction func goFindPass(_ sender: Any) {
        let authenVC =  signSB.instantiateViewController(withIdentifier: "TelephoneAuthenViewController") as!
        TelephoneAuthenViewController
        self.navigationController?.pushViewController(authenVC, animated: true)
        
    }
    
    @IBAction func goFindEmail(_ sender: Any) {
        let authenVC =  signSB.instantiateViewController(withIdentifier: "TelephoneAuthenViewController") as!
        TelephoneAuthenViewController
        self.navigationController?.pushViewController(authenVC, animated: true)
    }
    
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmail.endEditing(true)
        tfPass.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == tfEmail){
            tfPass.becomeFirstResponder()
        }
        return true
    }
    
    func setUI(){
        emailValidationLabel.isHidden = true
        passValidationLabel.isHidden = true
        tfEmail.becomeFirstResponder()
        tfPass.isEnabled = false
        loginBtn.isEnabled = false
    }

    //TextField에 대한 옵저버 처리
    func setTextFieldObserver(){
        //새로운 패스워드 TF에 대한 옵저버
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfEmail, queue: .main, using : {
            _ in
            let str = self.tfEmail.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView1.backgroundColor = UIColor.black
                self.tfPass.isEnabled = true
            }else {
                self.selectorImageView1.backgroundColor = UIColor.gray
                self.tfPass.isEnabled = false
            }
            
        })
        
        
        //패스워드 확인 TF에 대한 옵저버
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfPass, queue: .main, using : {
            _ in
            let str = self.tfPass.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView2.backgroundColor = UIColor.black
                self.loginBtn.backgroundColor = UIColor.black
                self.loginBtn.isEnabled = true
            }else {
                self.selectorImageView2.backgroundColor = UIColor.gray
                self.loginBtn.backgroundColor = UIColor.gray
                self.loginBtn.isEnabled = false
            }
            
        })
    }
    
    
}
