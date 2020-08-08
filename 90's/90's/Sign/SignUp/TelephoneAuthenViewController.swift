//
//  TelephoneAuthenViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class TelephoneAuthenViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var tfAuthenNumber: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var pathImageVIew: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var askNumberBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    //isSocial = true이면 카카오톡 회원가입 (EnterView -> AuthenView)
    //isSocial = false이면 자체 회원가입 (EnterView -> EmailView -> PassView -> AuthenView)
    var isSocial:Bool!
    var email:String!
    var pwd:String?
    var nickName:String!
    var telephone:String!
    var isAppleId:Bool!
    
    var isClicked = false
    var isInitial1 = false
    var isInitial2 = false
    var authenFlag = false
    var keyboardFlag = false
    var authenNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        //소셜로그인일 시 뒤로가기 클릭 시 메인화면
        if(isSocial){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchEnterView()
        }else {
            //아닐 시 닉네임 입력화면
            navigationController?.popViewController(animated: true)
        }
        
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
        goAuthen()
    }
    
    //UI
    func setUI(){
        validationLabel.isHidden = true
        okBtn.isEnabled = false
        okBtn.layer.cornerRadius = 8.0
        askNumberBtn.layer.cornerRadius = 8.0
        titleLabel.textLineSpacing(firstText: "마지막 단계입니다!", secondText: "전화번호를 입력해 주세요")
        
        if(isSocial){
            pathImageVIew.isHidden = true
            numberLabel.isHidden = true
        }
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
                    print("send telephone certification success")
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
    
    func goAuthen(){
        //서버에서 보내준 인증번호와 입력한 인증번호가 일치하는지 확인
        guard let inputAuthenNumber = tfAuthenNumber.text else { return }
        guard let number = authenNumber else { return }
        if(inputAuthenNumber == number){
            goSign()
        }else{
            validationLabel.isHidden = false
        }
    }
    
    
    func goSign(){
        SignUpService.shared.signUp(email: email, name: nickName, password: pwd, phone: telephone, sosial: isSocial, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let signUpResult = try? decoder.decode(SignUpResult.self, from: data)
                    guard let jwt = signUpResult?.jwt else { return }
                    
                    //소셜로그인일때만 정보저장(회원가입이 곧 로그인이 되기 때문)
                    if(self.isSocial){
                        UserDefaults.standard.set(self.email, forKey: "email")
                        UserDefaults.standard.set(self.isSocial, forKey: "social")
                        UserDefaults.standard.set(jwt, forKey: "jwt")
                        UserDefaults.standard.set(self.isAppleId, forKey: "isAppleId")
                    }
                    let completeVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController
                    completeVC.isSocial = self.isSocial
                    self.navigationController?.pushViewController(completeVC, animated: true)
                    break
                case 400...404:
                    self.showErrAlert()
                    print("SignUp : client Err \(response.error)")
                    break
                case 500:
                    self.showErrAlert()
                    print("SignUp : server Err \(response.error)")
                    break
                default:
                    return
                }
            }
            
        })
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "회원가입 불가", preferredStyle: .alert)
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
