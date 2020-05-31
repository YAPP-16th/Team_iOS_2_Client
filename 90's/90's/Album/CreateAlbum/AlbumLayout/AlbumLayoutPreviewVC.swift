//
//  AlbumLayoutPreviewPC.swift
//  90's
//
//  Created by 성다연 on 2020/04/19.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class AlbumLayoutPreviewVC: UIViewController {
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBAction func cancleBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let photoStringArray : [String] = ["preview1","preview2","preview3","preview4","preview5","preview6"]
    var photoArray : [UIImage] = []
    var selectedLayout : AlbumLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumLayoutPreviewVC {
    func defaultSetting(){
        layoutCollectionView.delegate = self
        layoutCollectionView.dataSource = self
        
        photoArray = photoStringArray.map({(value : String) -> UIImage in
            return UIImage(named: value)!
        } )
    }
}


extension AlbumLayoutPreviewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "albumlayoutheadercell", for: indexPath) as! AlbumLayoutHeaderCell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumlayoutpreviewcell", for: indexPath) as! AlbumLayoutPreviewCell
        let size = returnLayoutPreviewSize(selectedLayout: selectedLayout)
        cell.backimageView = applyBackImageViewLayout(selectedLayout: selectedLayout, smallBig: size,  imageView: cell.backimageView)
        cell.imageView = applyImageViewLayout(selectedLayout: selectedLayout, smallBig: size, imageView: cell.imageView, image: photoArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        returnLayoutPreviewSize(selectedLayout: selectedLayout)
    }
}
