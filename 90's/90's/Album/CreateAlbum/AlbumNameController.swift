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
    @IBOutlet weak var tfAlbumName: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var nextLabelHeight: NSLayoutConstraint!
    
    
    
    
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
        
        
        // iPhone X..
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height +
            UIApplication.shared.statusBarFrame.size.height
            
            self.nameLabel.frame.size = CGSize(width: self.nameLabel.frame.width, height: (self.view.frame.height - navigationBarHeight) * (0.0880196))
            
            self.nextBtn.frame.size = CGSize(width: self.nextBtn.frame.width, height: (self.view.frame.height - navigationBarHeight) * (0.0880196))
            
            
        }
    
        
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
        nextBtn.layer.cornerRadius = 10
        nextBtn.isEnabled = false
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAlbumName, queue: .main, using : {
            _ in
            let str = self.tfAlbumName.text!.trimmingCharacters(in: .whitespaces)
            
            if !str.isEmpty {
                self.selectorLabel.backgroundColor = UIColor.black
                self.nextBtn.backgroundColor = UIColor.colorRGBHex(hex: 0xe33e28)
                self.nextBtn.isEnabled = true
            }else {
                self.selectorLabel.backgroundColor = UIColor.lightGray
                self.nextBtn.backgroundColor = UIColor.lightGray
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
        
        buttonConstraint.constant = iPhone8Model() ? nextBtn.frame.height/2 - (keyboardHeight + 16) : -(keyboardHeight + 10)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
       }

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConstraint.constant = -16
    }
}
