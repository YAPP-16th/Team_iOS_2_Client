//
//  AlbumPeriodController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/04.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation
import UIKit

class AlbumPeriodController : UIViewController {
    
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
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumQuantityController") as! AlbumQuantityController
           
            nextVC.albumName = albumName
            nextVC.albumStartDate = tfOpenDate.text!
            nextVC.albumEndDate = tfExpireDate.text!
           
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    var albumName:String!
    var initialFlag = true
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOpenDate()
        keyboardSetting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfExpireDate.endEditing(true)
    }
}


extension AlbumPeriodController {
    //앨범 시작일은 현재 날짜로 고정
    func setOpenDate(){
        formatter.dateFormat = "yyyy.MM.dd"
        tfOpenDate.text = formatter.string(from: Date())
        tfExpireDate.placeholder = formatter.string(from: Date())
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
    
    //datePicker값 변경될 때 마다 TF의 값 변경되게 설정
    @objc func changePickerValue(){
        tfExpireDate.text = formatter.string(from: datePicker.date)
        
        if(initialFlag){
            self.selectorLabel1.backgroundColor = UIColor.black
            self.selectorLabel2.backgroundColor = UIColor.black
            self.nextBtn.backgroundColor = UIColor.colorRGBHex(hex: 0xe33e28)
            self.nextBtn.isEnabled = true
            initialFlag = false
        }
    }
}


extension AlbumPeriodController {
    func keyboardSetting(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
