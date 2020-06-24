//
//  AuthenViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/13.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AuthenViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var tfAuthenNumber: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var askNumberBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    var email:String!
    var pwd:String?
    var nickName:String!
    var telephone:String!
    var social: Bool!
    var isClicked = false
    var isInitial1 = false
    var isInitial2 = false
    var authenType: String!
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
    
    //확인 버튼 클릭 시
    @IBAction func clickOkBtn(_ sender: Any) {
        goAuthen(authenType: authenType)
    }
    
    //UI
    func setUI(){
        validationLabel.isHidden = true
        
        //인증 타입에 맞게 버튼 타이틀 변경
        switch authenType {
        case "findEmail":
            okBtn.setTitle("이메일 찾기", for: .normal)
            break
        case "findPass":
            okBtn.setTitle("비밀번호 찾기", for: .normal)
            break
        default:
            break
        }
        
        okBtn.isEnabled = false
        okBtn.layer.cornerRadius = 8.0
        askNumberBtn.layer.cornerRadius = 8.0
        titleLabel.textLineSpacing(firstText: "전화번호를", secondText: "인증해 주세요")
    }
    
    //Observer
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
    
    func getAuthenNumber(){
        telephone = tfTelephone.text!.replacingOccurrences(of: "-", with: "")
        //서버에서 문자를 보내고, 보낸 인증번호 받는 메소드
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
    
    func goAuthen(authenType : String){
        guard let inputAuthenNumber = tfAuthenNumber.text else { return }
        guard let number = authenNumber else { return }
        if(inputAuthenNumber == number){
            switch authenType {
            case "findEmail":
                self.findEmail()
            case "findPass":
                let profileSB = UIStoryboard(name: "Profile", bundle: nil)
                let newPassVC = profileSB.instantiateViewController(withIdentifier: "NewPassViewController") as! NewPassViewController
                newPassVC.authenType = "MainFindPass"
                newPassVC.phoneNum = self.telephone
                navigationController?.pushViewController(newPassVC, animated: true)
            default:
                return
            }
        }else{
            validationLabel.isHidden = false
        }
    }
    
    func findEmail(){
        FindEmailService.shared.findEmail(phoneNum: self.telephone, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let findEmailResult = try? decoder.decode(FindEmailResult.self, from: data) else { return }
                    let findEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "FindEmailViewController") as! FindEmailViewController
                    findEmailVC.email = findEmailResult.email
                    findEmailVC.nickName = findEmailResult.name
                    self.navigationController?.pushViewController(findEmailVC, animated: true)
                    break
                case 400:
                    let decoder = JSONDecoder()
                    guard let data = response.data else { return }
                    guard let errResult = try? decoder.decode(FindEmailErrResult.self, from: data) else { return }
                    if(errResult.message == "User is not exist"){
                        let findEmailErrVC = self.storyboard?.instantiateViewController(withIdentifier: "FindEmailErrViewController") as! FindEmailErrViewController
                        self.navigationController?.pushViewController(findEmailErrVC, animated: true)
                    }
                    break
                case 401...500:
                    self.showFindEmailAlert()
                    break
                default:
                    return
                }
            }
            
        })
        
    }
    
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "인증번호 전송 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func showFindEmailAlert(){
        let alert = UIAlertController(title: "오류", message: "이메일 찾기 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        let frameHeight = self.view.frame.height
        print("\(frameHeight)")
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
