//
//  MakeNewPassViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/11.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class MakeNewPassViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfNewPass: UITextField!
    @IBOutlet weak var tfConfirmPass: UITextField!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //다음 버튼 클릭 시 액션
    @IBAction func clickNextBtn(_ sender: Any) {
        let newPass = tfNewPass.text!
        let confirmPass = tfConfirmPass.text!
        if(newPass == confirmPass){
            //바뀐 패스워드를 서버로 보내는 코드 작성
            //성공 시 화면 전환
            let completeVC = storyboard?.instantiateViewController(withIdentifier: "CompleteNewPassViewController") as! CompleteNewPassViewController
            completeVC.newPass = tfNewPass.text!
            
            navigationController?.pushViewController(completeVC, animated: true)
        }else {
            validationLabel.isHidden = false
        }
    }
    
    func setUI(){
        tfNewPass.delegate = self
        tfConfirmPass.delegate = self
        nextBtn.isEnabled = false
        tfConfirmPass.isEnabled = false
        validationLabel.isHidden = true
        nextBtn.layer.cornerRadius = 8.0
    }
    
    func setObserver(){
        //새로운 패스워드 TF에 대한 옵저버
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfNewPass, queue: .main, using : {
            _ in
            let str = self.tfNewPass.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView1.image = UIImage(named: "path378Black")
                self.tfConfirmPass.isEnabled = true
            }else {
                self.selectorImageView1.image = UIImage(named: "path378Grey1")
                self.tfConfirmPass.isEnabled = false
            }
            
        })
        
        //패스워드 확인 TF에 대한 옵저버
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfConfirmPass, queue: .main, using : {
            _ in
            let str = self.tfConfirmPass.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView2.image = UIImage(named: "path378Black")
                self.nextBtn.backgroundColor = UIColor(displayP3Red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
                self.nextBtn.isEnabled = true
            }else {
                self.selectorImageView2.image = UIImage(named: "path378Grey1")
                self.nextBtn.backgroundColor = UIColor(displayP3Red: 199/255,green: 201/255, blue: 208/255, alpha: 1.0)
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
        tfNewPass.endEditing(true)
        tfConfirmPass.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == tfNewPass){
            tfConfirmPass.becomeFirstResponder()
        }
        return true
    }
    
}
