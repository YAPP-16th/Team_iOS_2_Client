//
//  TelephoneViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class TelephoneViewController: UIViewController {
    
    @IBOutlet weak var tfTelephone: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var athenticationBtn: UIButton!

    var isInitial1 = false
    var isInitial2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        athenticationBtn.isEnabled = false
        tfTelephone.becomeFirstResponder()
        
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
                self.selectorImageView.backgroundColor = UIColor.black
                self.athenticationBtn.backgroundColor = UIColor.black
                self.athenticationBtn.isEnabled = true
            }else {
                self.isInitial1 = false
                self.isInitial2 = false
                self.selectorImageView.backgroundColor = UIColor.gray
                self.athenticationBtn.backgroundColor = UIColor.gray
                self.athenticationBtn.isEnabled = false
            }
            
        })
        
    }
    
    
    @IBAction func goAuthenVC(_ sender: Any) {
        let telePhoneAuthenVC = storyboard?.instantiateViewController(identifier: "TelephoneAuthenViewController") as! TelephoneAuthenViewController
        navigationController?.pushViewController(telePhoneAuthenVC, animated: true)
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
