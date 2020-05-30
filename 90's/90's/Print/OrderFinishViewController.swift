//
//  OrderFinishViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class OrderFinishViewController : UIViewController {
    
    @IBOutlet weak var goBackAlbumBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var orderCode:String = ""
    var price:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goBackAlbumBtn.layer.cornerRadius = 10
        orderCodeLabel.text = "주문번호:" + orderCode
        priceLabel.text = "\(price.numberToPrice(price))원"
    }
    

    
    
    @IBAction func cancelgotoAlbum(_ sender: Any) {
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
    }
    

    
}

