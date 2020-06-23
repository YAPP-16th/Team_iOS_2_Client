//
//  AlbumNameController.swift
//  90's
//
//  Created by 성다연 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class AlbumNameVC : UIViewController {
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfAlbumName: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextLabelHeight: NSLayoutConstraint!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickNextBtn(_ sender : Any){
        let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumPeriodController") as! AlbumPeriodVC
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


extension AlbumNameVC : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfAlbumName.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfAlbumName.resignFirstResponder()
        return true
    }
}


extension AlbumNameVC {
    func textFieldSetting(){
        tfAlbumName.delegate = self
        tfAlbumName.becomeFirstResponder()
        tfAlbumName.clearButtonMode = .whileEditing
    }
    
    func defaultSetting(){
        nextBtn.layer.cornerRadius = 10
        nextBtn.isEnabled = false
        nameLabel.textLineSpacing(firstText: "이 앨범은 어떤 앨범인가요?", secondText: "이름을 정해 주세요 :)")
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAlbumName, queue: .main, using : {
            _ in
            let str = self.tfAlbumName.text!.trimmingCharacters(in: .whitespaces)
            
            if !str.isEmpty {
                self.selectorLabel.backgroundColor = UIColor.black
                self.nextBtn.switchComplete(next: true)
            } else {
                self.selectorLabel.backgroundColor = UIColor.lightGray
                self.nextBtn.switchComplete(next: false)
            }
        })
    }
    
    func keyboardSetting(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension AlbumNameVC {
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        buttonConstraint.constant = iPhone8Model() ? nextBtn.frame.height/2 - (keyboardHeight + 16) : -(keyboardHeight + 10)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
       }

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConstraint.constant = -16
    }
}
