//
//  NicknameViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class NicknameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tfNickname: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonConst: NSLayoutConstraint!
    
    var email:String!
    var pwd:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setObserver()
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickNextBtn(_ sender: Any) {
        let telephoneAuthenVC = storyboard?.instantiateViewController(withIdentifier: "TelephoneAuthenViewController") as! TelephoneAuthenViewController
        telephoneAuthenVC.email = email
        telephoneAuthenVC.pwd = pwd
        telephoneAuthenVC.isSocial = false
        telephoneAuthenVC.nickName = tfNickname.text!
        navigationController?.pushViewController(telephoneAuthenVC, animated: true)
    }
    
    func setUI(){
        tfNickname.delegate = self
        nextBtn.layer.cornerRadius = 8.0
         titleLabel.textLineSpacing(firstText: "닉네임을", secondText: "입력해 주세요")
    }
    
    func setObserver(){
        //tf에 대한 Observer
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfNickname, queue: .main, using : {
            _ in
            let str = self.tfNickname.text!.trimmingCharacters(in: .whitespaces)
            
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
        tfNickname.endEditing(true)
    }
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfNickname.resignFirstResponder()
        return true
    }
    
}
