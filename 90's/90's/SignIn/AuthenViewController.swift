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
    
    var email:String!
    var pwd:String!
    var telephone:String!
    var isClicked = false
    var isInitial1 = false
    var isInitial2 = false
    var authenType: String = ""
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
        goAuthen(authenType: authenType)
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
    
    func goAuthen(authenType : String){
        //인증번호가 맞는지 서버에 요청을 보내는 메소드 필요, 임시 인증번호(1111)
        //현재는 화면만 넘어가게 구현
        //인증번호가 맞고, 이메일이 존재할 시 이메일 확인 화면으로
        //인증번호가 맞고, 이메일이 존재하지 않을 시 이메일 확인 에러 화면으로 가야함
        let authenNumber = tfAuthenNumber.text!
        if(authenNumber == "1111"){
            switch authenType {
            case "findEmail":
                if(tfTelephone.text == "111-1111-1111"){
                    let findEmailVC = storyboard?.instantiateViewController(identifier: "FindEmailViewController") as! FindEmailViewController
                    navigationController?.pushViewController(findEmailVC, animated: true)
                }else{
                    let findEmailErrVC = storyboard?.instantiateViewController(identifier: "FindEmailErrViewController") as! FindEmailErrViewController
                    navigationController?.pushViewController(findEmailErrVC, animated: true)
                }
            case "findPass":
                let makePassVC = storyboard?.instantiateViewController(identifier: "MakeNewPassViewController") as! MakeNewPassViewController
                navigationController?.pushViewController(makePassVC, animated: true)
            default:
                print("")
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
