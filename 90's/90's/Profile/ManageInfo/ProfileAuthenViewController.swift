//
//  EmailPhoneViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/02.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ProfileAuthenViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var tfAuthenNumber: UITextField!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var askNumberBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    //이메일 변경인지 패스워드 변경인지 구분할 인덱스
    var authenType:String!
    
    var telephone:String!
    var isClicked = false
    var isInitial1:Bool = false
    var isInitial2:Bool = false
    var authenFlag = false
    var authenNumber:String?
    var keyboardFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //전송 버튼 클릭 시
    @IBAction func askNumber(_ sender: Any) {
        if(!authenFlag){
            askNumberBtn.setTitle("재전송", for: .normal)
            authenFlag = true
        }
        getAuthenNumber()
        
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
        goAuthen()
    }
    
    func setUI(){
        
        titleLabel.text = authenType
        subTitleLabel.textLineSpacing(firstText: "전화번호를", secondText: "입력해 주세요")
        validationLabel.isHidden = true
        okBtn.isEnabled = false
        okBtn.layer.cornerRadius = 8.0
        askNumberBtn.layer.cornerRadius = 8.0
        
    }
    
    func setObserver(){
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfTelephone, queue: .main, using : {
            _ in
            let str = self.tfTelephone.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                if(str.count == 3 && !self.isInitial1 ){
                    self.tfTelephone.text = self.tfTelephone.text! + "-"
                    self.isInitial1 = true
                }else if(str.count == 8 && !self.isInitial2){
                    self.tfTelephone.text = self.tfTelephone.text! + "-"
                    self.isInitial2 = true
                }
                self.selectorImageView1.image = UIImage(named: "path378Black")
                self.askNumberBtn.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
                self.askNumberBtn.isEnabled = true
            }else {
                self.isInitial1 = false
                self.isInitial2 = false
                self.selectorImageView1.image = UIImage(named: "path378Grey1")
                self.askNumberBtn.backgroundColor = UIColor(red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
                self.askNumberBtn.isEnabled = false
            }
            
        })
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAuthenNumber, queue: .main, using : {
            _ in
            let str = self.tfAuthenNumber.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView2.image = UIImage(named: "path378Black")
                self.okBtn.backgroundColor = UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
                self.okBtn.isEnabled = true
            }else {
                self.selectorImageView2.image = UIImage(named: "path378Grey1")
                self.okBtn.backgroundColor =  UIColor(red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
                self.okBtn.isEnabled = false
            }
            
        })
        
        //키보드에 대한 Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func goAuthen(){
        //서버에서 보내준 인증번호와 입력한 인증번호가 일치하는지 확인
        guard let inputAuthenNumber = tfAuthenNumber.text else { return }
        guard let number = authenNumber else { return }
        if(inputAuthenNumber == number){
            if(authenType == "이메일 변경"){
                let newEmailVC = storyboard?.instantiateViewController(withIdentifier: "NewEmailViewController") as! NewEmailViewController
                navigationController?.pushViewController(newEmailVC, animated: true)
            }else if(authenType == "비밀번호 변경"){
                let newPassVC = storyboard?.instantiateViewController(withIdentifier: "NewPassViewController") as! NewPassViewController
                newPassVC.phoneNum = self.telephone
                navigationController?.pushViewController(newPassVC, animated: true)
            }else {
                changePhone()
            }
        }else{
            validationLabel.isHidden = false
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        let frameHeight = self.view.frame.height
        if(frameHeight >= 736.0){
            //iphone6+, iphoneX ... (화면이 큰 휴대폰)
            buttonConst.constant = keyboardHeight - 18
        }else if(!keyboardFlag){
            //~iphone8, iphone7 (화면이 작은 휴대폰)
            keyboardFlag = true
            topConst.constant += 70
            self.view.frame.origin.y -= keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        let frameHeight = self.view.frame.height
        
        if(frameHeight >= 736.0){
            //iphoneX~
            buttonConst.constant = 18
        }else if(keyboardFlag){
            //~iphone8
            keyboardFlag = false
            topConst.constant -= 70
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfTelephone.endEditing(true)
        tfAuthenNumber.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfTelephone.resignFirstResponder()
        return true
    }
    
}

extension ProfileAuthenViewController {
    //서버에서 문자를 보내고, 보낸 인증번호 받는 메소드
    func getAuthenNumber(){
        telephone = tfTelephone.text!.replacingOccurrences(of: "-", with: "")
        TelephoneAuthService.shared.telephoneAuth(phone: telephone, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let telephoneAuthResult = try? decoder.decode(TelephoneAuthResult.self, from: data)
                    guard let num = telephoneAuthResult?.num else { return }
                    self.authenNumber = num
                    break
                case 401...404:
                    let alert = UIAlertController(title: "오류", message: "인증번호 전송 불가", preferredStyle: .alert)
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
    
    //전화번호 변경 서버통신 메소드
    func changePhone(){
        ChangePhoneService.shared.changePhone(phoneNum: self.telephone, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    //기존의 정보 다 삭제(자체로그인 시 저장하는 정보 : email, password, social, jwt)
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "social")
                    UserDefaults.standard.removeObject(forKey: "jwt")
                    self.goCompleteVC()
                    break
                case 401...404:
                    self.showErrAlert()
                    break
                case 500:
                    self.showErrAlert()
                    break
                default:
                    return
                }
            }
            
        })
    }
    
    func goCompleteVC() {
        let completeVC = storyboard?.instantiateViewController(withIdentifier: "CompleteManageViewController") as! CompleteManageViewController
        completeVC.authenType = self.authenType
        completeVC.telePhone = self.tfTelephone.text!
        navigationController?.pushViewController(completeVC, animated: true)
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "전화번호 변경 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
