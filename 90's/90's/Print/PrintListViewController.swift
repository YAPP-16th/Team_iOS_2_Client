//
//  PrintListViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit


class PrintListViewController: UIViewController {
    
    //IBOutlets..
    @IBOutlet weak var printListTableView: UITableView!
    @IBOutlet weak var gotoAlbum: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var demoAlbumImage: UIImageView!
    @IBOutlet weak var cautionTitle: UILabel!
    
    var completeAlbums : [album] = []
    var photoUidArray:[Int] = []
    var dispatchGroup = DispatchGroup()
    
    //주문내역 상세에 들어갈 데이터
    var orderData:GetOrderResult!
    var cost = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoAlbumImage.isHidden = true
        cautionTitle.isHidden = true
        gotoAlbum.isHidden = true
        self.gotoAlbum.layer.cornerRadius = 8
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getCompleteAlbums()
        if tabBarController?.tabBar.isHidden == true {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    @IBAction func clickGoToAlbum(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func getCompleteAlbums(){
        AlbumService.shared.albumGetAlbums(completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([album].self, from: data) else {return}
                    self.completeAlbums = value.filter{ $0.complete == true }
                    if(self.completeAlbums.count != 0){
                        self.getPhotoCount()
                    }else {
                        self.setPrintMainUI()
                    }
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in AlbumMain - getAlbums")
                default:
                    return
                }
            }
        })
    }
    
    func getPhotoCount(){
        for i in 0...completeAlbums.count-1 {
            dispatchGroup.enter()
            AlbumService.shared.photoGetPhoto(albumUid: completeAlbums[i].uid, completion: { response in
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        guard let data = response.data else {return}
                        guard let value = try? JSONDecoder().decode([PhotoGetPhotosData].self, from: data) else {
                            return}
                        self.photoUidArray.append(value.count)
                        self.dispatchGroup.leave()
                    case 401:
                        print("\(status) : bad request, no warning in Server")
                    case 404:
                        print("\(status) : Not found, no address")
                    case 500 :
                        print("\(status) : Server error in AlbumDetailVC - getPhoto")
                    default:
                        return
                    }
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main){
            self.setPrintMainUI()
        }
    }
    
    
    
    func setPrintMainUI(){
        if completeAlbums.count != 0 {
            printListTableView.delegate = self
            printListTableView.dataSource = self
            printListTableView.reloadData()
        }else {
            demoAlbumImage.isHidden = false
            cautionTitle.isHidden = false
            gotoAlbum.isHidden = false
            printListTableView.isHidden = true
        }
    }
}


extension PrintListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completeAlbums.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = printListTableView.dequeueReusableCell(withIdentifier: "PrintListTableViewCell", for :indexPath) as! PrintListTableViewCell
        let item = completeAlbums[indexPath.row]
        
        cell.albumImageView.image = getCoverByUid(value: item.cover.uid)
        
        
        
        let startDate = item.created_at.split(separator: "T")[0]
        let endDate = item.endDate
        
        let idxStartDate:String.Index = startDate.index(startDate.startIndex, offsetBy: 2)
        let idxEndDate:String.Index = endDate.index(endDate.startIndex, offsetBy: 2)
        
        let startDateStr = String(startDate[idxStartDate...]).replacingOccurrences(of: "-", with: ".")
        let endDateStr = String(endDate[idxEndDate...]).replacingOccurrences(of: "-", with: ".")
        
        cell.albumDate.text = startDateStr + "~" + endDateStr
        cell.albumTitle.text = item.name
        cell.pictureCount.text = "\(photoUidArray[indexPath.row])/\(item.photoLimit)"
        
        let orderStatus = item.orderStatus.status
        
        //앨범 인화 Stauts : pending, processing, ready, shipping, done
        switch orderStatus{
        case "pending":
            cell.orderBtn.setBackgroundImage(UIImage(named: "pending"), for: .normal)
            break
        case "processing":
            cell.orderBtn.setBackgroundImage(UIImage(named: "processingButton"), for: .normal)
            break
        case "ready":
            cell.orderBtn.setBackgroundImage(UIImage(named: "readyButton"), for: .normal)
            break
        case "shipping":
            cell.orderBtn.setBackgroundImage(UIImage(named: "shippingButton"), for: .normal)
            break
        case "done":
            cell.orderBtn.setBackgroundImage(UIImage(named: "doneButton"), for: .normal)
            cell.albumTitle.textColor = UIColor(red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
            cell.albumDate.textColor = UIColor(red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
            cell.pictureCount.textColor = UIColor(red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
            break
        default:
            break
        }
        
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.currentIndex = indexPath.row
        
        return cell
    }
    
}


extension PrintListViewController : ClickActionDelegate {
    
    func didClickedLink(index: Int) {
        switch completeAlbums[index].orderStatus.status {
        case "pending":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
            vc.albumInfo = completeAlbums[index]
            vc.photoCount = self.photoUidArray[index]
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "processing", "ready", "shipping", "done":
            let selectedAlbumIndex = completeAlbums[index].uid
            self.getOrder(albumUid: selectedAlbumIndex)
            break
        default:
            break
        }
    }
    
    func getOrder(albumUid: Int){
        GetOrderService.shared.getOrder(completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    guard let value = try? decoder.decode([GetOrderResult].self, from: data) else { return }
                    self.orderData = value.filter {$0.album.uid == albumUid}.first!
                    self.cost = Int(self.orderData.cost)!
                    let profileSB = UIStoryboard.init(name: "Profile", bundle: nil)
                    let orderDetailVC = profileSB.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                    orderDetailVC.orderData = self.orderData
                    orderDetailVC.cost = self.cost
                    self.navigationController?.pushViewController(orderDetailVC, animated: true)
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
        let alert = UIAlertController(title: "오류", message: "주문내역 상세 조회 불가", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
}
