//
//  AlbumInvitedVC.swift
//  90's
//
//  Created by 성다연 on 2020/05/18.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumInvitedVC: UIViewController {
    @IBOutlet weak var albumInvitedTF: UITextField!
    @IBOutlet weak var albumInvitedLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBAction func cancleBtn(_ sender: UIButton) {
        // 앱 종료
    }
    
    var albumIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        buttonSetting()
    }
}


extension AlbumInvitedVC : UITextFieldDelegate {
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         albumInvitedTF.endEditing(true)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         albumInvitedTF.resignFirstResponder()
         return true
     }
    
    func defaultSetting(){
        albumInvitedTF.delegate = self
        albumInvitedTF.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: albumInvitedTF, queue: .main, using: { _ in
            let value = self.albumInvitedTF.text!.trimmingCharacters(in: .whitespaces)
            if !value.isEmpty {
                if value.count >= 4 {
                    self.completeBtn.backgroundColor = UIColor.black
                    self.completeBtn.isEnabled = true
                    self.albumInvitedLabel.backgroundColor = UIColor.black
                    
                }
            } else {
                self.completeBtn.backgroundColor = UIColor.lightGray
                self.completeBtn.isEnabled = false
                self.albumInvitedLabel.backgroundColor = UIColor.lightGray
            }
        })
    }
    
    func buttonSetting(){
        completeBtn.addTarget(self, action: #selector(touchCompleteBtn), for: .touchUpInside)
    }
    
    @objc func touchCompleteBtn(){
        // 서버통신 후
        print("Touch")
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailController
        nextVC.albumUid = albumIndex
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
}
