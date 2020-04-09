//
//  TelephoneAuthenViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class TelephoneAuthenViewController: UIViewController {
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    @IBOutlet weak var tfAuthenNumber: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var email:String!
    var pwd:String!
    var telephone:String!
    var time = 180
    var timer = Timer()
    var isStartTimer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTelephone.text = telephone
        tfTelephone.isEnabled = false
        validationLabel.isHidden = true
        okBtn.isEnabled = false
        
        startTimer()
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAuthenNumber, queue: .main, using : {
            _ in
            let str = self.tfAuthenNumber.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView1.backgroundColor = UIColor.black
                self.selectorImageView2.backgroundColor = UIColor.black
                self.okBtn.backgroundColor = UIColor.black
                self.okBtn.isEnabled = true
            }else {
                self.selectorImageView1.backgroundColor = UIColor.gray
                self.selectorImageView2.backgroundColor = UIColor.black
                self.okBtn.backgroundColor = UIColor.black
                self.okBtn.isEnabled = true
            }
            
        })
        
        
    }
    
    @IBAction func clickOkBtn(_ sender: Any) {
        //인증번호가 맞는지 서버에 요청을 보내는 메소드 필요, 임시 인증번호(1111)
        let authenNumber = tfAuthenNumber.text!
        if(authenNumber == "1111"){
            //인증번호가 맞으면 회원가입 할 email, pwd, telephoneNumber를 서버로 보내고 회원가입
            //현재는 화면만 넘어가게 구현
            let completeVC = storyboard?.instantiateViewController(identifier: "CompleteViewController") as! CompleteViewController
            navigationController?.pushViewController(completeVC, animated: true)
        }else{
            validationLabel.isHidden = false
        }
    }
    
    //타이머 실행 메소드
    //타임아웃이 될 때 어떤식으로 화면이 전환되는지에 대해 논의 필요!!!
    func startTimer(){
        if(!isStartTimer){
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
                _ in
                if(self.time > 0){
                    self.time -= 1
                    self.timeLabel.text = "\(self.time/60):\(self.time%60)"
                }else{
                    self.isStartTimer = true
                    self.timer.invalidate()
                }
            }
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
