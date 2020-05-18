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
    @IBOutlet weak var albumMakeBtn:UIButton!
    @IBOutlet weak var albumIntroLabel: UILabel!
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBAction func clickMakeBtn(_ sender: Any){
        let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumNameController") as! AlbumNameController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCoverUidArray : [Int] = []
    var albumCoverArray : [UIImage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
        AlbumMainreloadView()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         settingCollectionView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        albumCoverUidArray = []
        albumCoverArray = []
    }
}


extension AlbumMainController {
    func settingCollectionView(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumMakeBtn.layer.cornerRadius = 10
        albumIntroLabel.text = "앨범을 만들어\n소중한 추억을 쌓아보세요"
    }
    
    func defaultSetting(){
        if(AlbumDatabase.arrayList.count != 0){
            introView.isHidden = true
            albumView.isHidden = false
        }else {
            introView.isHidden = false
            albumView.isHidden = true
        }
        self.tabBarController?.tabBar.isHidden = false
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
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in mainalbum - getalbums")
                default:
                    return
                }
            }
        })
    }
    
    func networkCoverUidSetting(){
        for i in 0...albumUidArray.count-1 {
        AlbumService.shared.photoGetPhoto(albumUid: albumUidArray[i], completion: { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200 :
                    guard let data = response.data else {return}
                    guard let value = try? JSONDecoder().decode([PhotoDownloadData].self, from: data) else {return}
                    self.albumCoverUidArray.append(value[0].photoUid)
                    self.networkCoverImageSetting()
                case 401:
                    print("\(status) : bad request, no warning in Server")
                case 404:
                    print("\(status) : Not found, no address")
                case 500 :
                    print("\(status) : Server error in mainalbum - getphoto")
                default:
                    return
                }
            }
        })
        }
    }
    
    func networkCoverImageSetting(){
        for i in 0...albumCoverUidArray.count-1 {
            AlbumService.shared.photoDownload(albumUid: albumUidArray[i], photoUid: albumCoverUidArray[i], completion: { response in
                if case .success(let image) = response.result {
                    self.albumCoverArray.append(image)
                    self.albumCollectionView.reloadData()
                }
            })
        }
    }
}



extension AlbumMainController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailVC = storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailController
        albumDetailVC.albumUid = albumUidArray[indexPath.row]
        albumDetailVC.isAlbumCount = true
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}


extension AlbumMainController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCoverArray.count-1//AlbumDatabase.arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.imageView.image =  albumCoverArray[indexPath.row+1]
        cell.nameLabel.text = albumNameArray[indexPath.row]
    
        return cell
    }
}


extension AlbumMainController : AlbumMainVCProtocol {
    func AlbumMainreloadView() {
        self.networkSetting()
        self.albumCollectionView.reloadData()
    }
}
