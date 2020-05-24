//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

var isDeviseVersionLow : Bool = false // 이건 임시방편....

protocol AlbumMainVCProtocol {
    func AlbumMainreloadView()
}

class AlbumMainController: UIViewController {
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBAction func clickMakeBtn(_ sender: Any){
        let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumNameController") as! AlbumNameController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBOutlet weak var emptyAlbumView: UIView!
    @IBOutlet weak var emptyAlbumMakeBtn: UIButton!
    @IBOutlet weak var emptyAlbumLabel: UILabel!
    
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCoverUidArray : [Int] = []
    var albumCoverArray : [UIImage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkSetting()
        self.tabBarController?.tabBar.isHidden = false
        print("AlbumMainVC  : viewWillAppear")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         settingCollectionView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        albumCoverArray = []
        albumCoverUidArray = []
    }
}


extension AlbumMainController {
    func settingCollectionView(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        emptyAlbumLabel.text = "앨범을 만들어\n소중한 추억을 쌓아보세요"
    }
    
    func switchAlbumEmptyView(value : Bool){
           switch value {
           case true:
               self.emptyAlbumView.isHidden = true
               self.emptyAlbumMakeBtn.isEnabled = false
               self.albumView.isHidden = false
           case false:
               self.emptyAlbumView.isHidden = false
               self.emptyAlbumMakeBtn.isEnabled = true
               self.albumView.isHidden = true
           }
       }
    
    func networkSetting(){
        AlbumService.shared.albumGetAlbums(completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([album].self, from: data) else {return}
                    self.albumUidArray = value.map({$0.uid})
                    self.albumNameArray = value.map({$0.name})
                    self.networkCoverUidSetting()
                    self.albumUidArray.isEmpty ? self.switchAlbumEmptyView(value: false) : self.switchAlbumEmptyView(value: true)
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
    
    func networkCoverUidSetting(){
        if albumUidArray.count > 0 {
        
        for i in 0...albumUidArray.count-1 {
            AlbumService.shared.photoGetPhoto(albumUid: albumUidArray[i], completion: { response in
                if let status = response.response?.statusCode {
                    switch status {
                    case 200 :
                        guard let data = response.data else {return}
                        guard let value = try? JSONDecoder().decode([PhotoDownloadData].self, from: data) else {return}
                        guard let pUid = value.first?.photoUid else {return}
                        self.albumCoverUidArray.append(pUid)
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
            })}
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                for i in 0...self.albumUidArray.count - 1 {
//                    self.networkCoverImageSetting(albumuid: self.albumUidArray[i], photouid: self.albumCoverUidArray[i])
                }
            }
        }
    }
    
    func networkCoverImageSetting(albumuid : Int, photouid : Int){
        AlbumService.shared.photoDownload(albumUid: albumuid, photoUid: photouid, completion: { response in
            if case .success(let image) = response.result {
                self.albumCoverArray.append(image)
                self.albumCollectionView.reloadData()
            }
        })
    }
}



extension AlbumMainController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailVC = storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailController
        albumDetailVC.albumUid = albumUidArray[indexPath.row]
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}


extension AlbumMainController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCoverArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.imageView.image =  albumCoverArray[indexPath.row]
        cell.nameLabel.text = albumNameArray[indexPath.row]
        return cell
    }
}


extension AlbumMainController : AlbumMainVCProtocol {
    func AlbumMainreloadView() {
        self.viewWillAppear(true)
        albumCollectionView.reloadData()
    }
}
