//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol AlbumMainVCProtocol {
    func AlbumMainreloadView()
}

class AlbumMainVC : UIViewController {
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var createAlbumBtn: UIButton!
    @IBOutlet weak var emptyAlbumView: UIView!
    @IBOutlet weak var emptyAlbumMakeBtn: UIButton!
    @IBOutlet weak var emptyAlbumLabel: UILabel!
    @IBAction func touchCreateBtn(_ sender: UIButton){
        let nextVC = storyboard?.instantiateViewController(withIdentifier : "AlbumNameController") as! AlbumNameVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    var albumUidArray : [Int] = []
    var albumNameArray : [String] = []
    var albumCoverUidArray : [Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkSetting()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumMainVC {
    func defaultSetting(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        emptyAlbumLabel.text = "앨범을 만들어\n소중한 추억을 쌓아보세요"
        createAlbumBtn.isHidden = isDefaultUser ? true : false
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
                    self.albumUidArray = value.map { $0.uid }
                    self.albumNameArray = value.map { $0.name }
                    self.albumCoverUidArray = value.map { $0.cover.uid }
                    self.albumUidArray.isEmpty ? self.switchAlbumEmptyView(value: false) : self.switchAlbumEmptyView(value: true)
                    self.albumCollectionView.reloadData()
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
}



extension AlbumMainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailVC = storyboard?.instantiateViewController(withIdentifier: "albumDetailVC") as! AlbumDetailVC
        albumDetailVC.albumUid = albumUidArray[indexPath.row]
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}


extension AlbumMainVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.imageView.image = getCoverByUid(value: albumCoverUidArray[indexPath.row])
        cell.nameLabel.text = albumNameArray[indexPath.row]
        return cell
    }
}


extension AlbumMainVC : AlbumMainVCProtocol {
    func AlbumMainreloadView() {
        albumCollectionView.reloadData()
    }
}
