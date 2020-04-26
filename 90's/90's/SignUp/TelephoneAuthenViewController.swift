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
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var askNumberBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    
    var email:String!
    var pwd:String!
    var nickName:String!
    var telephone:String!
    var isClicked = false
    var isInitial1 = false
    var isInitial2 = false
    var authenFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
        telephone = tfTelephone.text!
        goAuthen()
    }
    
    @IBAction func askNumber(_ sender: Any) {
        if(!authenFlag){
            askNumberBtn.setTitle("재전송", for: .normal)
            authenFlag = true
        }
        
    }
    func setUI(){
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
                self.askNumberBtn.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
                self.askNumberBtn.isEnabled = true
            }else {
                self.isInitial1 = false
                self.isInitial2 = false
                self.selectorImageView1.image = UIImage(named: "path378Grey1")
                self.askNumberBtn.backgroundColor = UIColor(displayP3Red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
                self.askNumberBtn.isEnabled = false
            }
            
        })
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAuthenNumber, queue: .main, using : {
            _ in
            let str = self.tfAuthenNumber.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView2.image = UIImage(named: "path378Black")
                self.okBtn.backgroundColor = UIColor(displayP3Red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
                self.okBtn.isEnabled = true
            }else {
                self.selectorImageView2.image = UIImage(named: "path378Grey1")
                self.okBtn.backgroundColor =  UIColor(displayP3Red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
                self.okBtn.isEnabled = false
            }
            
        })
        
        //키보드에 대한 Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func goAuthen(){
        //인증번호가 맞는지 서버에 요청을 보내는 메소드 필요, 임시 인증번호(1111)
        let authenNumber = tfAuthenNumber.text!
        if(authenNumber == "1111"){
            //인증번호가 맞으면 회원가입 할 email, pwd, telephoneNumber를 서버로 보내고 회원가입
            //현재는 화면만 넘어가게 구현
            goSign()
        }else{
            validationLabel.isHidden = false
        }
    }
    
    func goSign(){
        SignUpService.shared.signUp(email: email, name: nickName, password: pwd, phone: telephone, sosial: false, completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let signUpResult = try? decoder.decode(SignUpResult.self, from: data)
                    guard let token = signUpResult?.token else { return }
                    print("\(token)")
                    let completeVC = self.storyboard?.instantiateViewController(identifier: "CompleteViewController") as! CompleteViewController
                    self.navigationController?.pushViewController(completeVC, animated: true)
                    break
                case 400...404:
                    self.showErrAlert()
                    print("SignUp : client Err")
                    break
                case 500:
                    self.showErrAlert()
                    print("SignUp : server Err")
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
        tfTelephone.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfTelephone.resignFirstResponder()
        return true
    }
    
}
