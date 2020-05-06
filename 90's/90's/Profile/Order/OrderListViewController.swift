//
//  OrderListViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

enum Status: String {
    case wait = "입금대기"
    case confirm = "입금확인"
    case ready = "배송준비"
    case deliver = "배송중"
    case complete = "배송완료"
}

struct Order {
    var albumImage:String
    var albumStatus:Status
    var albumName:String
    var albumPrice:Int
    var albumNum:Int
}

protocol OrderDetailDelegate {
    func clickDetailBtn(_ index : Int)
}

class OrderListViewController: UIViewController {
    @IBOutlet weak var noAlbumView: UIView!
    @IBOutlet weak var orderListTableView: UITableView!
    var isExistAlbum = false
    
    //더미데이터
    var orderList = [Order(albumImage: "mysweetyLovesyou", albumStatus: .wait, albumName: "현창이의 행복한 앨범1", albumPrice: 20000, albumNum: 1), Order(albumImage: "mysweetyLovesyou", albumStatus: .confirm, albumName: "현창이의 행복한 앨범2", albumPrice: 20000, albumNum: 1), Order(albumImage: "mysweetyLovesyou", albumStatus: .ready, albumName: "현창이의 행복한 앨범3", albumPrice: 20000, albumNum: 1), Order(albumImage: "mysweetyLovesyou", albumStatus: .deliver, albumName: "현창이의 행복한 앨범4", albumPrice: 20000, albumNum: 1), Order(albumImage: "mysweetyLovesyou", albumStatus: .complete, albumName: "현창이의 행복한 앨범5", albumPrice: 20000, albumNum: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //인화하러가기 버튼 클릭 시 액션
    @IBAction func clickPrintBtn(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func setUI(){
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        
        //앨범이 존재하지 않을 시 주문내역 테이블뷰 히든 처리
        if(!isExistAlbum){
            orderListTableView.isHidden = true
        }
    }
    
}

extension OrderListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = storyboard?.instantiateViewController(identifier: "OrderDetailViewController") as! OrderDetailViewController
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        let orderData = orderList[indexPath.row]
        cell.albumImageView.image = UIImage(named: orderData.albumImage)
        
        switch orderData.albumStatus {
        case .wait:
            cell.statusImageView.backgroundColor = UIColor(red: 227/255, green: 62/255, blue: 40/255, alpha: 1.0)
        case .ready, .confirm, .deliver:
            cell.statusImageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            break
        case .complete:
            cell.statusImageView.backgroundColor = UIColor(red: 199/255, green: 201/255, blue: 208/255, alpha: 1.0)
            break
        }
        
        cell.statusLabel.text = orderData.albumStatus.rawValue
        cell.albumNameLabel.text = orderData.albumName
        cell.albumPriceLabel.text = orderData.albumPrice.numberToPrice(orderData.albumPrice) + " 원"
        cell.orderNumberLabel.text = "\(orderData.albumNum)개"
        return cell
    }
}


