//
//  OrderListViewController.swift
//  90's
//
//  Created by 홍정민 on 2020/04/26.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol OrderDetailDelegate {
    func clickDetailBtn(_ index : Int)
}

class OrderListViewController: UIViewController {
    @IBOutlet weak var noAlbumView: UIView!
    @IBOutlet weak var orderListTableView: UITableView!
    
    var orderList:[GetOrderResult] = []
    var cost = 0
    
    override func viewWillAppear(_ animated: Bool) {
        getOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //주문앨범이 없을 시 출력 -> 인화하러 가기 버튼 클릭 시 액션
    @IBAction func clickPrintBtn(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func setUI(){
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
    }
    
    func getOrder(){
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        GetOrderService.shared.getOrder(token: jwt, completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let value = try? decoder.decode([GetOrderResult].self, from: data) else { return }
                    print("orderList \(value)")
                    self.orderList = value.filter
                        {$0.album.orderStatus.status != "pending"}
                    print("filtered OrderList \(value)")
                    self.orderListTableView.reloadData()
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
        let alert = UIAlertController(title: "오류", message: "주문내역 조회 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}

extension OrderListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        let item = orderList[indexPath.row]
        
        //statusCode에 따라 이미지 변경
        let orderStatus = item.album.orderStatus.status
        switch orderStatus{
        case "processing":
            cell.statusImageView.image = UIImage(named: "processingTag")
            break
        case "ready":
            cell.statusImageView.image = UIImage(named: "paymentConfirmation")
            break
        case "shipping":
            cell.statusImageView.image = UIImage(named: "shipmentInProgress")
            break
        case "done":
            cell.statusImageView.image = UIImage(named: "deliveryCompleted")
            break
        default:
            break
        }
        
        //앨범 커버 이미지 설정
        cell.albumImageView.image = getCoverByUid(value: item.album.cover.uid)
        
        //앨범 이름
        cell.albumNameLabel.text = item.album.name
        
        cost = Int(item.cost)!
        
        //앨범 가격
        cell.albumPriceLabel.text = cost.numberToPrice(cost)+"원"
        
        //앨범 개수
        cell.orderNumberLabel.text = "\(item.amount)개"
        return cell
    }
}


