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
    
    var email:String!
    var pwd:String!
    var telephone:String!
    var isClicked = false
    var isInitial1 = false
    var isInitial2 = false
    var authenType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
        if(!isClicked){
            self.tfAuthenNumber.isHidden = false
            selectorImageView2.isHidden = false
            self.okBtn.setTitle("확인", for: .normal)
            self.okBtn.isEnabled = false
            self.okBtn.backgroundColor = UIColor.gray
            self.titleLabel.text = "인증번호를\n입력해주세요"
            self.tfTelephone.isEnabled = false
            isClicked = !isClicked
        }else{
            goAuthen(authenType: authenType)
        }
    }
    
    func setUI(){
        tfAuthenNumber.isHidden = true
        selectorImageView2.isHidden = true
        validationLabel.isHidden = true
        okBtn.isEnabled = false
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
                self.selectorImageView1.backgroundColor = UIColor.black
                self.okBtn.backgroundColor = UIColor.black
                self.okBtn.isEnabled = true
            }else {
                self.isInitial1 = false
                self.isInitial2 = false
                self.selectorImageView1.backgroundColor = UIColor.gray
                self.okBtn.backgroundColor = UIColor.gray
                self.okBtn.isEnabled = false
            }
            
        })
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAuthenNumber, queue: .main, using : {
            _ in
            let str = self.tfAuthenNumber.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView2.backgroundColor = UIColor.black
                self.okBtn.backgroundColor = UIColor.black
                self.okBtn.isEnabled = true
            }else {
                self.selectorImageView2.backgroundColor = UIColor.gray
                self.okBtn.backgroundColor = UIColor.gray
                self.okBtn.isEnabled = false
            }
            
        })
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
