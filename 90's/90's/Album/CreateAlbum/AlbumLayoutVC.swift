//
//  AlbumLayoutVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/08.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumLayoutVC: UIViewController {
    @IBOutlet weak var layoutImageView: UIImageView!
    @IBOutlet weak var layoutLabel: UILabel!
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBAction func completeBtn(_ sender: UIButton) {
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "AlbumCompleteVC") as! AlbumCompleteVC
                   
            nextVC.albumName = albumName
            nextVC.albumStartDate = albumStartDate
            nextVC.albumEndDate = albumEndDate
            nextVC.albumMaxCount = albumMaxCount
            nextVC.albumCover = albumCover
            nextVC.photo = photo
            nextVC.albumLayout = albumLayout
                    
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func layoutPreviewBtn(_ sender: UIButton) {
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "albumlayoutpreviewvc") as! AlbumLayoutPreviewVC
            nextVC.selectedLayout = albumLayout
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate let layoutCellStringArray : [String] = [
        "layoutThumbnailPolaroid", "layoutThumbnailMini","layoutThumbnailMemory","layoutThumbnailPortrab","layoutThumbnailTape", "layoutThumbnailPortraw", "layoutThumbnailFilmroll",]
    fileprivate let layoutImageStringArray : [String] = [
        "layoutPolaroid", "layoutMini","layoutMemory", "layoutPortrab", "layoutTape", "layoutPortraw", "layoutFilmroll"
    ]

    fileprivate var layoutImageArray : [UIImage] = []
    fileprivate var layoutCellArray : [UIImage] = []
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var albumCover : Int!
    var photo : UIImage!
    var albumLayout : AlbumLayout!
    
    var initialFlag : Bool = true
    var selectedCell : albumLayoutCollectionCell?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumLayoutVC {
    func defaultSetting(){
        layoutCellArray = layoutCellStringArray.map({(value : String) -> UIImage in
            return UIImage(named: value)!
        })
        layoutImageArray = layoutImageStringArray.map({(value : String) -> UIImage in
            return UIImage(named: value)!
        })
        if albumLayout == nil {
            layoutImageView.image = UIImage(named: "emptyimage")
        }
        layoutCollectionView.delegate = self
        layoutCollectionView.dataSource = self
        layoutLabel.textLineSpacing(firstText: "앨범 레이아웃을", secondText: "선택해 주세요")
    }
}


extension AlbumLayoutVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutCellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumlayoutcell", for: indexPath) as! albumLayoutCollectionCell
        cell.imageView.image = layoutCellArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        layoutImageView.image = layoutImageArray[indexPath.row]
        albumLayout = LayoutDatabase.arrayList[indexPath.row]
        initialFlag = false
        
        let cell = collectionView.cellForItem(at: indexPath) as! albumLayoutCollectionCell
        if selectedCell != nil {
            selectedCell?.selectImageView.isHidden = true
        }
        selectedCell = cell
        cell.selectImageView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 102)
    }
}


class albumLayoutCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
