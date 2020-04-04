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
    @IBOutlet weak var selectorImageView1: UIImageView!
    @IBOutlet weak var selectorImageView2: UIImageView!
    
    var albumName:String!
    var initialFlag = true
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    
    override func viewWillAppear(_ animated: Bool) {
        setOpenDate()
    }
    
    override func viewDidLoad() {
        setDatePicker()
    }
    
    
    //다음 버튼 눌렀을 시 액션
    @IBAction func clickNextBtn(_ sender: Any) {
        let albumQuantityVC = storyboard?.instantiateViewController(withIdentifier : "AlbumQuantityController") as! AlbumQuantityController
        
        albumQuantityVC.albumName = albumName
        albumQuantityVC.startDate = tfOpenDate.text!
        albumQuantityVC.expireDate = tfExpireDate.text!
        

            self.navigationController?.pushViewController(albumQuantityVC, animated: true)
        
    }
    
    //앨범 시작일은 현재 날짜로 고정
    func setOpenDate(){
        formatter.dateFormat = "yyyy년 M월 d일"
        tfOpenDate.text = formatter.string(from: Date())
    }
    
    //앨범 마감일 설정 시 datePicker 설정
    func setDatePicker(){
        datePicker.datePickerMode = .date
        
        //datePicker 한글 설정
        datePicker.locale = NSLocale(localeIdentifier: "ko-KO") as Locale
        
        tfExpireDate.inputView = datePicker
        datePicker.addTarget(self, action:#selector(changePickerValue), for: .valueChanged)
    }
    
    //datePicker값 변경될 때 마다 TF의 값 변경되게 설정
    @objc func changePickerValue(){
        tfExpireDate.text = formatter.string(from: datePicker.date)
        
        if(initialFlag){
            self.selectorImageView1.backgroundColor = UIColor.black
            self.selectorImageView2.backgroundColor = UIColor.black
            self.nextBtn.backgroundColor = UIColor.black
            self.nextBtn.isEnabled = true
            initialFlag = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfExpireDate.endEditing(true)
    }
    
    
}

