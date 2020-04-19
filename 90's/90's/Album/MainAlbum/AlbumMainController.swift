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
    func reloadView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultSetting()
        reloadView()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         settingCollectionView()
     }
}



extension AlbumMainController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetailVC = storyboard?.instantiateViewController(identifier: "albumDetailVC") as! AlbumDetailController
        albumDetailVC.albumIndex = indexPath.row
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}


extension AlbumMainController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumDatabase.arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.imageView.image =  AlbumDatabase.arrayList[indexPath.row].photos[0]
        cell.nameLabel.text = AlbumDatabase.arrayList[indexPath.row].albumName
    
        return cell
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
}


extension AlbumMainController : AlbumMainVCProtocol {
    func reloadView() {
        self.albumCollectionView.reloadData()
    }
}
