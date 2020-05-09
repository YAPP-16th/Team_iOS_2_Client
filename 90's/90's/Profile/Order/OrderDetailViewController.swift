//
//  OrderDetailViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/01.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    //앨범 정보
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumOptionLabel: UILabel!
    @IBOutlet weak var albumPriceLabel: UILabel!
    @IBOutlet weak var albumNumLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //배송 정보
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    //결제 정보
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var depositPeriodLabel: UILabel!
    
   //커스텀 주문취소 뷰
    @IBOutlet weak var sheetHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    //주문취소뷰 - 취소, 확인 버튼
    @IBOutlet weak var cancelOptionBtn: UIButton!
    @IBOutlet weak var okOptionBtn: UIButton!
    
    var copyStr:String!
    var orderStatus: Status!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //주문 취소 버튼 클릭 시 액션
    @IBAction func clickCancelBtn(_ sender: Any) {
        showActionView()
    }
    
    //주문 취소 시트 -> 취소 버튼 클릭
    @IBAction func orderCancel(_ sender: Any) {
        dismissActionView()
    }
    
    //주문 취소 시트 -> 확인 버튼 클릭
    @IBAction func clickOkBtn(_ sender: Any) {
        dismissActionView()
    }
    
    //복사하기 버튼 클릭 시 액션
    @IBAction func clickCopyBtn(_ sender: Any) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = copyStr
    }
    
    func setUI(){
        //Label 텍스트 일부만 DemiLight
        let attributedString = NSMutableAttributedString(string: accountLabel.text!, attributes: [
            .font: UIFont(name: "NotoSansCJKkr-Bold", size: 14.0)!,
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-DemiLight", size: 14.0)!, range: NSRange(location: 0, length: 4))
        accountLabel.attributedText = attributedString

        //복사할 string
        let str = accountLabel.text!
        let startIndex = str.index(str.startIndex, offsetBy: 5)
        let endIndex = str.endIndex
        let range = startIndex..<endIndex
        copyStr = String(str[range])
        
        //입금 대기 상태일 때만 주문취소 버튼 표시
        if(orderStatus == .wait){
            cancelBtn.isHidden = false
        }else {
            cancelBtn.isHidden = false
        }
        
        //주문취소 뷰
        imageView.isHidden = true
        sheetHeightConst.constant = 0
        cancelOptionBtn.layer.cornerRadius = 8.0
        okOptionBtn.layer.cornerRadius = 8.0
        
    }
    
    func showActionView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.isHidden = false
            self.sheetHeightConst.constant = 264
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissActionView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.isHidden = true
            self.sheetHeightConst.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}
