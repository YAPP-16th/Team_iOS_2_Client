//
//  AlbumCoverVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCoverVC: UIViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var coverCollectionView: UICollectionView!
    @IBAction func touchBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func completeBtn(_ sender: UIButton) {
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "AlbumLayoutVC") as! AlbumLayoutVC
            nextVC.albumName = albumName
            nextVC.albumStartDate = albumStartDate
            nextVC.albumEndDate = albumEndDate
            nextVC.albumMaxCount = albumMaxCount
            nextVC.albumCover = albumCover
            nextVC.photo = photo
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var albumCover : Int!
    var photo : UIImage!
    
    var initialFlag : Bool = true
    var selectedCell : Int?//AlbumCoverCollectionCell?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if photo == nil {
            coverImageView.image = UIImage(named: "emptyimage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumCoverVC {
    func defaultSetting(){
        coverCollectionView.delegate = self
        coverCollectionView.dataSource = self
        coverLabel.text = "앨범 커버를\n선택해 주세요"
    }
}


extension AlbumCoverVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoverDatabase.arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell for item")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumcovercell", for: indexPath) as! AlbumCoverCollectionCell
        cell.imageView.image = CoverDatabase.arrayList[indexPath.row].image
        cell.selectImageView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item")
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumCoverCollectionCell
        selectedCell = indexPath.row
        cell.selectImageView.isHidden = false
        initialFlag = false
        photo = CoverDatabase.arrayList[indexPath.row].image
        coverImageView.image = CoverDatabase.arrayList[indexPath.row].image
        albumCover = indexPath.row + 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3 , height: self.view.frame.height/5)
    }
}
