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
    
    //배송 정보
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    //결제 정보
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var depositPeriodLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //주문 취소 버튼 클릭 시 액션
    @IBAction func clickCancelBtn(_ sender: Any) {
    }
    
    //복사하기 버튼 클릭 시 액션
    @IBAction func clickCopyBtn(_ sender: Any) {
    }
    
    func setUI(){
        //Label 텍스트 일부만 DemiLight
        let attributedString = NSMutableAttributedString(string: accountLabel.text!, attributes: [
            .font: UIFont(name: "NotoSansCJKkr-Bold", size: 14.0)!,
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansCJKkr-DemiLight", size: 14.0)!, range: NSRange(location: 0, length: 4))
        accountLabel.attributedText = attributedString
    }
    
}
