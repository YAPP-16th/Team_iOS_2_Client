//
//  photoStickerCollectionCell.swift
//  90's
//
//  Created by 성다연 on 2020/04/10.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

protocol AlbumDetailVCProtocol {
    func reloadView()
}

class AlbumDetailController : UIViewController {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var albumIndex:Int?
    var openAlbumCount : Int! // 앨범 낡기 적용
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoCollectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        defaultSetting()
        buttonSetting()
    }
}


extension AlbumDetailController {
    func delegateSetting(){
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    func defaultSetting(){
        albumNameLabel.text = AlbumDatabase.arrayList[albumIndex!].albumName
        albumCountLabel.text = "\(AlbumDatabase.arrayList[albumIndex!].photos.count - 1) 개의 추억이\n쌓였습니다"
    }
    
    func buttonSetting(){
        addPhotoBtn.addTarget(self, action: #selector(touchAddPhotoBtn), for: .touchUpInside)
        inviteBtn.addTarget(self, action: #selector(touchInviteBtn), for: .touchUpInside)
        infoBtn.addTarget(self, action: #selector(touchInfoBtn), for: .touchUpInside)
    }
}

extension AlbumDetailController {
    @objc func touchAddPhotoBtn() {
        if (AlbumDatabase.arrayList[albumIndex!].photos.count >= AlbumDatabase.arrayList[albumIndex!].albumMaxCount) {
            addPhotoBtn.isEnabled = false
            
            let alert = UIAlertController(title: "사진  추가 불가", message: "제한개수를 모두 채웠습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert,animated: true)
        }else {
            addPhotoBtn.isEnabled = true
        }
    }
    
    @objc func touchInviteBtn(){
        // 카카오 초대 창
    }
    
    @objc func touchInfoBtn(){
        // 앨범 정보 창
    }
}


extension AlbumDetailController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumDatabase.arrayList[albumIndex!].photos.count - 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.photoImageView.image = AlbumDatabase.arrayList[albumIndex!].photos[indexPath.row+1]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 26, height: view.frame.height/4 + 10)
    }
}


extension AlbumDetailController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAlbumPopupVC" {
            let dest = segue.destination as! AlbumDetailPopupVC
            dest.albumIndex = albumIndex!
        } else if segue.identifier == "GoToInfoVC" {
            let dest = segue.destination as! AlbumInfoVC
            dest.albumIndex = albumIndex!
        }
    }
}


extension AlbumDetailController : AlbumDetailVCProtocol {
    func reloadView() {
        self.photoCollectionView.reloadData()
        self.viewWillAppear(true)
        print("AlbumDetailVC reloaddata")
    }
}
