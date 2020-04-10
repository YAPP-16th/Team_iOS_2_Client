//
//  AlbumCompleteVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol AlbumMainVCProtocol {
    func reloadView()
}

class AlbumMainController: UIViewController {
    
    @IBOutlet weak var albumMakeBtn:UIButton!
    @IBOutlet weak var albumIntroLabel: UILabel!
    @IBOutlet weak var introView: UIView!
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
        let width = (self.view.frame.width / 2) - 15
        let height = self.view.frame.height / 4.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //cell 클릭 시 넘어갈 화면 분기
        //앨범 설정값이 nil -> AlbumSettingVC
        //앨범 설정값이 있고 테마값이 nil -> AlbumThemeVC
        //다 있으면 -> AlbumDetailVC
        
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
        let data = AlbumDatabase.arrayList[indexPath.row]
        if let photoNum = data.albumMaxCount {
            if(photoNum == data.photos.count){
                cell.isFull = true
            }
        }else {
            cell.isFull = false
        }
        
        cell.albumImageView.image =  data.photos.first ?? UIImage()
        cell.albumNameLabel.text = data.albumName
    
        return cell
    }
}


extension AlbumMainController {
    func settingCollectionView(){
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
    }
    
    func defaultSetting(){
        if(AlbumDatabase.arrayList.count != 0){
           introView.isHidden = true
        }else {
           introView.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
    }
}


extension AlbumMainController : AlbumMainVCProtocol {
    func reloadView() {
        self.albumCollectionView.reloadData()
    }
}
