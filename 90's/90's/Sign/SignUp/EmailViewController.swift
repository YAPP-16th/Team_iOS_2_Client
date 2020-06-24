//
//  EmailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Alamofire

class EmailViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var email:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNextBtn(_ sender: Any) {
        self.email = tfEmail.text!
        
        //string extension을 통해 정규식 검증
        if(email.validateEmail()){
            emailValidationLabel.isHidden = true
            checkEmail()
        }else {
            emailValidationLabel.isHidden = false
            emailValidationLabel.text = "이메일 확인 후 재시도 해주세요"
            selectorImageView.image = UIImage(named: "path378Red")
        }
    }
    
    func setUI(){
        tfEmail.delegate = self
        emailValidationLabel.isHidden = true
        nextBtn.layer.cornerRadius = 8.0
        titleLabel.textLineSpacing(firstText: "환영합니다!", secondText: "이메일을 입력해주세요")
    }
    
    func setObserver(){
        //tf에 대한 Observer
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfEmail, queue: .main, using : {
            _ in
            let str = self.tfEmail.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView.image = UIImage(named: "path378Black")
                self.nextBtn.backgroundColor = UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
                self.nextBtn.isEnabled = true
            }else {
                self.selectorImageView.image = UIImage(named: "path378Grey1")
                self.nextBtn.backgroundColor = UIColor(red: 199/255,green: 201/255, blue: 208/255, alpha: 1.0)
                self.nextBtn.isEnabled = false
            }
        })
        
        //키보드에 대한 Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        if(keyboardHeight > 300){
            buttonConst.constant = keyboardHeight - 18
        }else{
            buttonConst.constant = keyboardHeight + 18
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConst.constant = 18
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
    
    func goPassVC() {
        let passwordVC = storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        passwordVC.email = self.email
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
}


extension EmailViewController {
    
    func checkEmail(){
        EmailCheckService.shared.emailCheck(email: self.email, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let checkEmailResult = try? decoder.decode(CheckEmailResult.self, from: data)
                    guard let isExist = checkEmailResult?.result else { return }
                    if(isExist){
                        self.emailValidationLabel.isHidden = false
                        self.emailValidationLabel.text = "이미 존재하는 계정입니다"
                    }else {
                        self.goPassVC()
                    }
                    break
                case 401...404:
                    let alert = UIAlertController(title: "오류", message: "이메일 중복체크 불가", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    break
                default:
                    return
                }
            }
        })
        
    }
    
    
}


