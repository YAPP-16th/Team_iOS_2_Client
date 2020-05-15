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
    @IBOutlet weak var tfMemo: UITextField!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelOptionBtn: UIButton!
    @IBOutlet weak var okOptionBtn: UIButton!
    @IBOutlet weak var sheetHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    var agreeFlag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
    }
    
    //우편번호 검색 버튼 클릭
    @IBAction func clickSearchAddress(_ sender: Any) {
        let addressSearchVC = storyboard?.instantiateViewController(identifier: "AddressSearchViewController") as! AddressSearchViewController
        present(addressSearchVC, animated: true)
    }
    
    //내용확인 체크박스 클릭 시
    @IBAction func clickAgreeBtn(_ sender: Any) {
        let agreeBtn = sender as! UIButton
        if(!agreeFlag){
            agreeBtn.setBackgroundImage(UIImage(named: "checkboxActBlack"), for: .normal)
        }else {
            agreeBtn.setBackgroundImage(UIImage(named: "checkboxgray"), for: .normal)
        }
        agreeFlag = !agreeFlag
    }
    
    
    //결제하기 버튼 클릭 시
    @IBAction func clickPayBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderFinishViewController") as! OrderFinishViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationItem.title = " "
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "iconBack")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "iconBack")
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    func setUI(){
        self.navigationController?.isNavigationBarHidden = true
        for subView in self.contentView.subviews {
            if subView is UITextField{
                subView.layer.borderWidth = 1.0
                subView.layer.cornerRadius = 8.0
                subView.layer.borderColor = CGColor(srgbRed: 199/255, green: 201/255, blue: 208/255, alpha: 0.7)
            }
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
