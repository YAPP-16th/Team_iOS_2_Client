//
//  AlbumNameController.swift
//  90's
//
//  Created by 성다연 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class AlbumNameController : UIViewController {
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var tfAlbumName: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickNextBtn(_ sender : Any){
        let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumPeriodController") as! AlbumPeriodController
        nextVC.albumName = tfAlbumName.text!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        defaultSetting()
        keyboardSetting()
        textFieldSetting()
    }
}


extension AlbumNameController : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfAlbumName.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfAlbumName.resignFirstResponder()
        return true
    }
}


extension AlbumNameController {
    func textFieldSetting(){
        tfAlbumName.delegate = self
        tfAlbumName.becomeFirstResponder()
        tfAlbumName.clearButtonMode = .whileEditing
    }
    
    func defaultSetting(){
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAlbumName, queue: .main, using : {
            _ in
            let str = self.tfAlbumName.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView.backgroundColor = UIColor.black
                self.nextBtn.backgroundColor = UIColor.black
                self.nextBtn.isEnabled = true
                self.backView.backgroundColor = UIColor.black
            }else {
                self.selectorImageView.backgroundColor = UIColor.gray
                self.nextBtn.backgroundColor = UIColor.gray
                self.backView.backgroundColor = UIColor.gray
                self.nextBtn.isEnabled = false
            }
        })
    }
    
    func keyboardSetting(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension AlbumNameController {
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        // iphone8 : 260, 11 : 346
        if keyboardHeight > 300 { // iphone 11 !
            buttonConstraint.constant = nextBtn.frame.height/2 - keyboardHeight
            backView.isHidden = false
        }else { // iphone ~ 8
            buttonConstraint.constant = 10 - keyboardHeight
            backView.isHidden = true
            isDeviseVersionLow = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
       }

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConstraint.constant = 10
    }
}
