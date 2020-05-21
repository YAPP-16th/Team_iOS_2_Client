//
//  PrintListViewController.swift
//  90's
//
//  Created by 조경진 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

//Table View 들어감

class PrintListViewController: UIViewController {
    
    //IBOutlets..
    @IBOutlet weak var printListTableView: UITableView!
    @IBOutlet weak var gotoAlbum: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var demoAlbumImage: UIImageView!
    @IBOutlet weak var cautionTitle: UILabel!
    
    var completeAlbums : [album] = []
    
    //앨범 커버에 사용 할 변수
    var photoUidArray: [Int] = []
    var albumCoverArray: [UIImage] = []
    
    //통신에 사용할 Dispatch Group
    let dispatchGroup = DispatchGroup()

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
    
    
    
    func getCompleteAlbums(){
        AlbumService.shared.albumGetAlbums(completion: {
            response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([album].self, from: data) else {return}
                    self.completeAlbums = value.filter{ $0.complete == true }
                    print("\(value)")
                    self.getPhotoUid()
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
    
    //photoUid를 가져오는 코드
    func getPhotoUid(){
        for i in 0...completeAlbums.count - 1 {
            dispatchGroup.enter()
            
            AlbumService.shared.photoGetPhoto(albumUid: completeAlbums[i].uid, completion: { response in
                if let status = response.response?.statusCode {
                    switch status {
                    case 200 :
                        guard let data = response.data else {return}
                        guard let value = try? JSONDecoder().decode([PhotoDownloadData].self, from: data) else {return}
                        let pUid = value.first!.photoUid
                        self.photoUidArray.append(pUid)
                        self.dispatchGroup.leave()
                    case 401:
                        print("\(status) : bad request, no warning in Server")
                    case 404:
                        print("\(status) : Not found, no address")
                    case 500 :
                        print("\(status) : Server error in AlbumMain - getPhoto")
                    default:
                        return
                    }
                }
            })
        }
        dispatchGroup.notify(queue: .main){
            self.getAlbumCover()
        }
    }
    
    
    //첫번째 photoUid를 통해 표지를 가져오는 코드
    func getAlbumCover(){
        for i in 0...self.completeAlbums.count - 1 {
            self.dispatchGroup.enter()
            AlbumService.shared.photoDownload(albumUid: completeAlbums[i].uid, photoUid: photoUidArray[i], completion: {
                response in
                if case .success(let image) = response.result {
                    self.albumCoverArray.append(image)
                    self.dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main){
            self.setPrintMainUI()
        }

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
        
        cell.albumImageView.image = albumCoverArray[indexPath.row]
        
        let startDate = item.created_at.split(separator: "T")[0]
        let endDate = item.endDate.split(separator: "T")[0]
       
        let idxStartDate:String.Index = startDate.index(startDate.startIndex, offsetBy: 2)
        let idxEndDate:String.Index = endDate.index(endDate.startIndex, offsetBy: 2)
        
        let startDateStr = String(startDate[idxStartDate...]).replacingOccurrences(of: "-", with: ".")
        let endDateStr = String(endDate[idxEndDate...]).replacingOccurrences(of: "-", with: ".")
        
        cell.albumDate.text = startDateStr + "~" + endDateStr
        cell.albumTitle.text = item.name
        cell.pictureCount.text = "\(item.photoLimit)/\(item.photoLimit)"
        
        
        //아직 orderStatus의 값이 없기 때문에 서버API 나온 후 업데이트 예정
        
        if cell.state == 0 {
            cell.orderBtn.backgroundColor = .black
            cell.orderBtn.setTitle("결제 하기", for: .normal)
        }
        else if cell.state == 1 {
            //            rgb 227 62 40
            cell.orderBtn.backgroundColor = UIColor(displayP3Red: 225 / 255, green: 62 / 255, blue: 40 / 255, alpha: 1.0)
            cell.orderBtn.setTitle("결제 완료하기", for: .normal)
        }
        else if cell.state == 2 {
            cell.albumDate.textColor = .lightGray
            cell.albumTitle.textColor = .lightGray
            cell.pictureCount.textColor = .lightGray
            cell.orderBtn.backgroundColor = .lightGray
            cell.orderBtn.setTitle("신청 완료", for: .normal)
        }
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.currentIndex = indexPath.row
        
        return cell
    }
    
}


extension PrintListViewController : ClickActionDelegate {
    
    func didClickedLink(index: Int) {
        
        print("Clicked")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.tempImage = albumCoverArray[index]
        self.navigationController?.pushViewController(vc, animated: true)
        //        self.navigationController?.show(vc, sender: true)
        
        
        
    }
    
}
