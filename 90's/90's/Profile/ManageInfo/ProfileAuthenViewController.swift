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
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var tfAuthenNumber: UITextField!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var askNumberBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    
    //이메일 변경인지 패스워드 변경인지 구분할 인덱스
    var authenType:String!
    
    var telephone:String!
    var isClicked = false
    var isInitial1:Bool = false
    var isInitial2:Bool = false
    var authenFlag = false
    var authenNumber:String?
    
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
    
    func getAuthenNumber(){
        telephone = tfTelephone.text!.replacingOccurrences(of: "-", with: "")
        print("\(telephone)")
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
            if(authenType == "이메일 변경"){
                let newEmailVC = storyboard?.instantiateViewController(identifier: "NewEmailViewController") as! NewEmailViewController
                navigationController?.pushViewController(newEmailVC, animated: true)
            }else {
                let newPassVC = storyboard?.instantiateViewController(identifier: "NewPassViewController") as! NewPassViewController
                navigationController?.pushViewController(newPassVC, animated: true)
            }
        }else{
            validationLabel.isHidden = false
        }
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
