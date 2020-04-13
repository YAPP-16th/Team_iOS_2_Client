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
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBAction func completeBtn(_ sender: UIButton) {
        if initialFlag == false {
            let nextVC = storyboard?.instantiateViewController(identifier: "AlbumCompleteVC") as! AlbumCompleteVC
                   
            nextVC.albumName = albumName
            nextVC.albumStartDate = albumStartDate
            nextVC.albumEndDate = albumEndDate
            nextVC.albumMaxCount = albumMaxCount
            nextVC.photo = photo
            nextVC.albumLayout = albumLayout
                    
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate let layoutStringArray : [String] = ["layoutimg1","layoutimg2","layoutimg3","layoutimg4","layoutimg5","layoutimg6"]
    fileprivate var layoutArray : [UIImage] = []
    
    var albumName : String!
    var albumStartDate : String!
    var albumEndDate : String!
    var albumMaxCount : Int!
    var photo : UIImage!
    var albumLayout : Int!
    
    var initialFlag : Bool = true
    
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
        layoutArray = layoutStringArray.map({(value : String) -> UIImage in
            return UIImage(named: value)!
        })
        if albumLayout == nil {
            layoutImageView.image = UIImage(named: "emptyimage")
        }
        layoutCollectionView.delegate = self
        layoutCollectionView.dataSource = self
    }
}


extension AlbumLayoutVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumlayoutcell", for: indexPath) as! albumLayoutCollectionCell
        cell.imageView.image = layoutArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        layoutImageView.image = layoutArray[indexPath.row]
        albumLayout = indexPath.row
        initialFlag = false
        let cell = collectionView.cellForItem(at: indexPath) as! albumLayoutCollectionCell
        cell.selectImageView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! albumLayoutCollectionCell
        cell.selectImageView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 89, height: 126)
    }
}
