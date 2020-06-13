//
//  OrderFinalViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/05/12.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class OrderFinalViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var tfRecipient: UITextField!
    @IBOutlet weak var tfPostNumber: UITextField!
    @IBOutlet weak var addressSearchBtn: UIButton!
    @IBOutlet weak var tfMainAddress: UITextField!
    @IBOutlet weak var tfSubAddress: UITextField!
    @IBOutlet weak var tfTelephone1: UITextField!
    @IBOutlet weak var tfTelephone2: UITextField!
    @IBOutlet weak var tfTelephone3: UITextField!
    @IBOutlet weak var tvMemo: UITextView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelOptionBtn: UIButton!
    @IBOutlet weak var okOptionBtn: UIButton!
    @IBOutlet weak var sheetHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var albumInfo: album!
    var afterPrice:Int = 0
    var paperType = ""
    var shipType = ""
    var coverImage:UIImage!
    var layoutName:String!
    var num = 0
    var orderCode = ""
    
    var agreeFlag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRecognizer()
    }
    
    //네비게이션바 - 뒤로가기 버튼 클릭 시
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //네비게이션바 - X버튼 클릭 시
    @IBAction func closeOrder(_ sender: Any) {
        showActionView()
    }
    
    //취소 시트 -> 취소 버튼 클릭
    @IBAction func orderCancel(_ sender: Any) {
        dismissActionView()
    }
    
    //취소 시트 -> 확인 버튼 클릭
    @IBAction func clickOkBtn(_ sender: Any) {
        dismissActionView()
        navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
    }
    
    //우편번호 검색 버튼 클릭
    @IBAction func clickSearchAddress(_ sender: Any) {
        let addressSearchVC = storyboard?.instantiateViewController(withIdentifier: "AddressSearchViewController") as! AddressSearchViewController
        addressSearchVC.searchDelegate = self
        addressSearchVC.modalPresentationStyle = .fullScreen
        present(addressSearchVC, animated: true)
    }
    
    //내용확인 체크박스 클릭 시
    @IBAction func clickAgreeBtn(_ sender: Any) {
        let agreeBtn = sender as! UIButton
        if(!agreeFlag){
            agreeBtn.setBackgroundImage(UIImage(named: "checkboxActBlack"), for: .normal)
            payBtn.isEnabled = true
        }else {
            agreeBtn.setBackgroundImage(UIImage(named: "checkboxgray"), for: .normal)
            payBtn.isEnabled = false
        }
        agreeFlag = !agreeFlag
    }
    
    
    //결제하기 버튼 클릭 시
    @IBAction func clickPayBtn(_ sender: Any) {
        if(tfRecipient.text == "" || tfPostNumber.text == "" || tfTelephone1.text == "" || tfTelephone2.text == "" ||
            tfTelephone3.text == ""){
            self.showEmptyAlert()
        }else {
            self.goOrder()
        }
    }
    
    
    func setUI(){
        self.navigationController?.isNavigationBarHidden = true
        payBtn.isEnabled = false
        tfPostNumber.isEnabled = false
        tfMainAddress.isEnabled = false
        
        //주문제품 정보 설정
        coverImageView.image = coverImage
        albumNameLabel.text = albumInfo.name
        optionLabel.text =  "커버: \(albumInfo.cover.name) / 포토레이아웃: \(layoutName ?? "") / 인화용지: \(paperType) / 배송: \(shipType)"
        priceLabel.text = afterPrice.numberToPrice(afterPrice)
        numLabel.text = "\(num)개"
        
        //테두리, 코너 설정
        
        for subView in self.contentView.subviews {
            if subView is UITextField{
                subView.layer.borderWidth = 1.0
                subView.layer.cornerRadius = 8.0
                subView.layer.borderColor = UIColor(red: 219/255, green: 201/255, blue: 208/255, alpha: 0.7).cgColor
                (subView as! UITextField).addLeftPadding()
                subView.tintColor = UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
            }
            tvMemo.layer.borderWidth = 1.0
            tvMemo.layer.cornerRadius = 8.0
            tvMemo.layer.borderColor = UIColor(red: 219/255, green: 201/255, blue: 208/255, alpha: 0.7).cgColor
            tvMemo.tintColor = UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
            tvMemo.textContainerInset = UIEdgeInsets(top: 13.0, left: 12.0, bottom: 13.0, right: 12.0)
            if subView is UIButton {
                subView.layer.cornerRadius = 8.0
            }
        }
        
        //주문취소 뷰
        imageView.isHidden = true
        sheetHeightConst.constant = 0
        cancelOptionBtn.layer.cornerRadius = 8.0
        okOptionBtn.layer.cornerRadius = 8.0
        
        
    }
    
    func setRecognizer(){
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollviewTap))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func scrollviewTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func goOrder(){
        let phoneNum = tfTelephone1.text! + tfTelephone2.text!+tfTelephone3.text!
        
        
        //PaperType과 ShipType에 따라 Index 변환
        var paperTypeIndex = 0
        let paperType2Index = 1 //기본값
        var shipTypeIndex = 0
        
        if(paperType == "유광"){
            paperTypeIndex = 1
        }else {
            paperTypeIndex = 2
        }
        
        if(shipType == "일반"){
            shipTypeIndex = 1
        }else if(shipType == "특급(+10,000원)"){
            shipTypeIndex = 2
        }else {
            shipTypeIndex = 3
        }
        
        
        
        OrderService.shared.order(amount: num, albumUid: albumInfo.uid, recipient: tfRecipient.text!, postalCode: tfPostNumber.text!, address: tfMainAddress.text!, addressDetail: tfSubAddress.text ?? "", phoneNum: phoneNum, message: tvMemo.text ?? "", paperType1: paperTypeIndex, paperType2: paperType2Index, postType: shipTypeIndex, cost: "\(afterPrice)", completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    //데이터 디코딩
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let value = try? decoder.decode(OrderResult.self, from: data) else { return }
                    self.orderCode = value.orderCode
                    print("\(self.orderCode)")
                    //결제완료 내역으로 이동
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderFinishViewController") as! OrderFinishViewController
                    vc.orderCode = self.orderCode
                    vc.price = self.afterPrice
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case 401...500:
                    self.showErrAlert()
                    break
                default:
                    return
                }
            }
        })
    }
    
    func showErrAlert(){
        let alert = UIAlertController(title: "오류", message: "주문 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func showEmptyAlert(){
        let alert = UIAlertController(title: "입력 필요", message: "배송정보를 입력해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    func showActionView(){
        self.view.endEditing(true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension OrderFinalViewController : SearchAddressDelegate {
    func passSelectedAddress(_ roadAddress: String, _ numAddress: String, _ zipCode: String) {
        tfPostNumber.text = zipCode
        tfMainAddress.text = roadAddress
    }
    
    
}
