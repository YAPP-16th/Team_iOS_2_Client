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
    
    var selectedLayout : AlbumLayout!
    let photoArray : [UIImage] = [UIImage(named: "preview1")!, UIImage(named: "preview2")!,
                                  UIImage(named: "preview3")!, UIImage(named: "preview4")!,
                                  UIImage(named: "preview5")!, UIImage(named: "preview6")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
}


extension AlbumLayoutPreviewVC {
    func defaultSetting(){
        layoutCollectionView.delegate = self
        layoutCollectionView.dataSource = self
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
        let size = selectedLayout.size
        cell.backimageView = applyBackImageViewLayout(selectedLayout: selectedLayout, smallBig: size,  imageView: cell.backimageView)
        cell.imageView = applyImageViewLayout(selectedLayout: selectedLayout, smallBig: size, imageView: cell.imageView, image: photoArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        selectedLayout.size
    }
}



class AlbumLayoutHeaderCell: UICollectionViewCell {
}


class AlbumLayoutPreviewCell: UICollectionViewCell {
    @IBOutlet weak var backimageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backimageTop: NSLayoutConstraint!
    @IBOutlet weak var backimageLeft: NSLayoutConstraint!
    @IBOutlet weak var backimageRight: NSLayoutConstraint!
    @IBOutlet weak var backimageBottom: NSLayoutConstraint!
}
