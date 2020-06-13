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
    
    //커스텀 주문취소 뷰
    @IBOutlet weak var sheetHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    //주문취소뷰 - 취소, 확인 버튼
    @IBOutlet weak var cancelOptionBtn: UIButton!
    @IBOutlet weak var okOptionBtn: UIButton!
    
    //클립보드에 복사할 문자열
    var copyStr:String!
    
    //복사하기 클릭 시 나타나는 커스텀 뷰
    @IBOutlet weak var copyHeightConst: NSLayoutConstraint!
    
    
    //사용 데이터
    var orderData:GetOrderResult!
    var albumOrderUid:Int = 0
    var cost = 0
    
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
        cancelOrder()
    }
    
    //복사하기 버튼 클릭 시 액션
    @IBAction func clickCopyBtn(_ sender: Any) {
        showCopyView()
        //문자열 복사 코드
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = copyStr
    }
    
    func setUI(){
        if tabBarController?.tabBar.isHidden == false {
            tabBarController?.tabBar.isHidden = true
        }
        //계좌정보 텍스트 일부만 DemiLight
        let attributedString = NSMutableAttributedString(string: accountLabel.text!, attributes: [
            .font: UIFont(name: "NotoSansCJKkr-Bold", size: 14.0)!,
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-DemiLight", size: 14.0)!, range: NSRange(location: 0, length: 4))
        accountLabel.attributedText = attributedString
        
        //클립보드에 복사할 String
        let str = accountLabel.text!
        let startIndex = str.index(str.startIndex, offsetBy: 5)
        let endIndex = str.endIndex
        let range = startIndex..<endIndex
        copyStr = String(str[range])
        
        
        //앨범 정보
        albumOrderUid = orderData.uid
        
        albumImageView.image = getCoverByUid(value: orderData.album.cover.uid)
        albumNameLabel.text = orderData.album.name
        
        let layoutName = getLayoutByUid(value: orderData.album.layoutUid).layoutName
        let paperType = orderData.paperType1.uid
        let shipType = orderData.postType.uid
        
        
        var strPaperType = ""
        var strShipType = ""
        
        if(paperType == 1){
            strPaperType = "유광"
        }else{
            strPaperType = "무광"
        }
        
        if(shipType == 1){
            strShipType = "일반"
        }else if(shipType == 2){
            strShipType = "고급"
        }else {
            strShipType = "최고급"
        }
        
        albumOptionLabel.text = "커버: \(orderData.album.cover.name) / 포토레이아웃: \(layoutName) / 인화용지: \(strPaperType) / 배송: \(strShipType)"
        
        albumPriceLabel.text = "\(cost.numberToPrice(cost))원"
        albumNumLabel.text = "\(orderData.amount)개"
        orderNumberLabel.text = "주문번호: \(orderData.orderCode)"
        orderNumberLabel.sizeToFit()
        
        //입금 대기 상태일 때만 주문취소 버튼 표시
        if(orderData.album.orderStatus.status == "processing"){
            cancelBtn.isHidden = false
        }else {
            cancelBtn.isHidden = false
        }
        
        //배송정보
        nameLabel.text = orderData.recipient
        addressLabel.text = "(\(orderData.postalCode)) \(orderData.address) \(orderData.addressDetail)"
        phoneLabel.text = orderData.phoneNum
        memoLabel.text = orderData.message
        //결제 정보
        depositLabel.text = "\(cost.numberToPrice(cost))원"
        
        
        //주문취소 뷰
        imageView.isHidden = true
        sheetHeightConst.constant = 0
        cancelOptionBtn.layer.cornerRadius = 8.0
        okOptionBtn.layer.cornerRadius = 8.0
        
    }
    
    
    func cancelOrder(){
        print("\(albumOrderUid)")
        CancelOrderService.shared.cancelOrder(albumOrderUid: self.albumOrderUid, completion: {
            status in
            print("\(status)")
            switch(status){
            case 200:
                self.showSuccessAlert()
                break
            case 400...500:
                self.showErrAlert()
                break
            default:
                break
            }
        })
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "주문취소 완료", message: "주문취소 되었습니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "주문취소 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
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
    
    func showCopyView(){
        UIView.animate(withDuration: 1.0, animations: {
            self.imageView.isHidden = false
            self.copyHeightConst.constant = 264
            self.view.layoutIfNeeded()
        },completion: {
            _ in
            UIView.animate(withDuration: 0.9, animations: {
                self.copyHeightConst.constant = 0
                self.imageView.isHidden = true
                self.view.layoutIfNeeded()
            })
        })
    }
    
}
