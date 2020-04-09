//
//  AlbumNameController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation
import UIKit

class AlbumNameController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfAlbumName: UITextField!
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        tfAlbumName.delegate = self
        tfAlbumName.becomeFirstResponder()
        tfAlbumName.clearButtonMode = .whileEditing
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: tfAlbumName, queue: .main, using : {
            _ in
            let str = self.tfAlbumName.text!.trimmingCharacters(in: .whitespaces)
            
            if(str != ""){
                self.selectorImageView.backgroundColor = UIColor.black
                self.nextBtn.backgroundColor = UIColor.black
                self.nextBtn.isEnabled = true
            }else {
                self.selectorImageView.backgroundColor = UIColor.gray
                self.nextBtn.backgroundColor = UIColor.gray
                self.nextBtn.isEnabled = false
            }
        })
    }
    
    
    //다음 버튼 클릭 시 기간설정 화면으로 넘어가는 액션
    @IBAction func clickNextBtn(_ sender : Any){
        let albumPeriodVC = storyboard?.instantiateViewController(withIdentifier : "AlbumPeriodController") as! AlbumPeriodController
        
        let albumName = tfAlbumName.text!
        albumPeriodVC.albumName = albumName
        
        self.navigationController?.pushViewController(albumPeriodVC, animated: true)
    }
    
    
    //화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfAlbumName.endEditing(true)
    }
    
    
    //키보드 리턴 버튼 클릭 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfAlbumName.resignFirstResponder()
        return true
    }
}

