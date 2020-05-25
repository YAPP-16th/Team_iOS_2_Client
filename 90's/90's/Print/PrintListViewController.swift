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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoAlbumImage.isHidden = true
        cautionTitle.isHidden = true
        gotoAlbum.isHidden = true
        self.gotoAlbum.layer.cornerRadius = 8
        
        // iPhone X..
        if UIScreen.main.nativeBounds.height >= 1792.0 {
            
            self.topConstraint.constant = 244
            
        }
            // iPhone 8..
        else if UIScreen.main.nativeBounds.height <= 1334.0
        {
            self.topConstraint.constant = 112
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getCompleteAlbums()
    }
    
    @IBAction func clickGoToAlbum(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
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
                    self.setPrintMainUI()
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
    
    
    func setPrintMainUI(){
        if completeAlbums.count != 0 {
            printListTableView.delegate = self
            printListTableView.dataSource = self
            printListTableView.reloadData()
        }
        else {
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
        cell.pictureCount.text = "\(item.photoLimit)/\(item.photoLimit)"
        
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
            cell.albumTitle.textColor = UIColor(displayP3Red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
            cell.albumDate.textColor = UIColor(displayP3Red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
            cell.pictureCount.textColor = UIColor(displayP3Red: 153/255, green: 156/255, blue: 166/255, alpha: 1.0)
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
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        //        self.navigationController?.show(vc, sender: true)
        
        
        
    }
    
}
