//
//  AlbumPeriodController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation
import UIKit

class AlbumPeriodVC : UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tfOpenDate: UITextField!
    @IBOutlet weak var tfExpireDate: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectorLabel1: UILabel!
    @IBOutlet weak var selectorLabel2: UILabel!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickNextBtn(_ sender: Any) {
        if !tfExpireDate.text!.isEmpty {
            let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumQuantityController") as! AlbumQuantityVC
           
            nextVC.albumName = albumName
            nextVC.albumStartDate = tfOpenDate.text!
            nextVC.albumEndDate = tfExpireDate.text!
           
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    var albumName:String!
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        keyboardSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfExpireDate.endEditing(true)
    }
}


extension AlbumPeriodVC {
    //앨범 시작일은 현재 날짜로 고정
    func defaultSetting(){
        formatter.dateFormat = "yyyy.MM.dd"
        tfOpenDate.text = formatter.string(from: Date())
        tfExpireDate.placeholder = formatter.string(from: Date())
        label.textLineSpacing(firstText: "앨범의 기간을 정해주세요", secondText: nil)
        nextBtn.layer.cornerRadius = 10
    }
    
    //앨범 마감일 설정 시 datePicker 설정
    func setDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.backgroundColor = .white
        
        //datePicker 한글 설정
        datePicker.locale = NSLocale(localeIdentifier: "ko-KO") as Locale
        tfExpireDate.becomeFirstResponder()
        
        tfExpireDate.inputView = datePicker
        datePicker.addTarget(self, action:#selector(changePickerValue), for: .valueChanged)
    }
    
    func keyboardSetting(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension AlbumPeriodVC {
    @objc func changePickerValue(){
           tfExpireDate.text = formatter.string(from: datePicker.date)
           
           self.selectorLabel1.backgroundColor = UIColor.black
           self.selectorLabel2.backgroundColor = UIColor.black
           self.nextBtn.switchComplete(next: true)
       }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        buttonConstraint.constant = datePicker.frame.height + 10
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
       }

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonConstraint.constant = 16
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: {self.view.layoutIfNeeded()})
    }
}
