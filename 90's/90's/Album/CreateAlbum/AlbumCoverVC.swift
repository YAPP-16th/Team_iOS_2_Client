//
//  AlbumCoverVC.swift
//  90's
//
//  Created by 성다연 on 2020/04/09.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumCoverVC: UIViewController {
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverCollectionView: UICollectionView!
    
    @IBAction func touchBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate var coverStringArray : [String] = ["cover1", "cover2", "cover3", "cover4"]
    fileprivate var coverArray : [UIImage] = []
    fileprivate var selectIndex : Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coverArray = coverStringArray.map({ (value : String) -> UIImage in
            return UIImage(named: value)!
        })
        
        coverImageView.image = coverArray[selectIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
    }
}


extension AlbumCoverVC {
    func delegateSetting(){
        coverCollectionView.delegate = self
        coverCollectionView.dataSource = self
    }
}


extension AlbumCoverVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coverArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumcovercell", for: indexPath) as! AlbumCoverCollectionCell
        cell.imageView.image = coverArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        coverImageView.image = coverArray[selectIndex]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: 108)
    }
}
