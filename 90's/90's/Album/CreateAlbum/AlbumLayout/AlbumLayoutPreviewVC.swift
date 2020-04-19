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
        
        switch selectedLayout {
        case .Polaroid :
            cell.backimageView.image = AlbumLayout.Polaroid.image
            cell.backimageView.frame.size = AlbumLayout.Polaroid.size
            cell.imageView.frame = CGRect(x: 10, y: 10, width: cell.contentView.frame.size.width - 20, height: cell.contentView.frame.size.height - 40)
        case .Mini :
            cell.backimageView.image = AlbumLayout.Mini.image
            cell.backimageView.frame.size = AlbumLayout.Mini.size
        case .Memory :
            cell.backimageView.image = AlbumLayout.Memory.image
            cell.backimageView.frame.size = AlbumLayout.Memory.size
        case .Portrab :
            cell.backimageView.image = AlbumLayout.Portrab.image
            cell.backimageView.frame.size = AlbumLayout.Portrab.size
        case .Tape :
            cell.backimageView.image = AlbumLayout.Tape.image
            cell.backimageView.frame.size = AlbumLayout.Tape.size
        case .Portraw :
            cell.backimageView.image = AlbumLayout.Portraw.image
            cell.backimageView.frame.size = AlbumLayout.Portraw.size
        case .Filmroll :
            cell.backimageView.image = AlbumLayout.Filmroll.image
            cell.backimageView.frame.size = AlbumLayout.Filmroll.size
        default: cell.backimageView.image = AlbumLayout.Polaroid.image
        }
        cell.imageView.image = photoArray[indexPath.row]
        print("backview size = \(cell.backimageView.frame), image size = \(cell.imageView.frame)")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        switch selectedLayout {
        case .Polaroid : return AlbumLayout.Polaroid.size
        case .Mini : return AlbumLayout.Mini.size
        case .Memory : return AlbumLayout.Memory.size
        case .Portrab : return AlbumLayout.Portrab.size
        case .Tape : return AlbumLayout.Tape.size
        case .Portraw : return AlbumLayout.Portraw.size
        case .Filmroll : return AlbumLayout.Filmroll.size
        default : return AlbumLayout.Polaroid.size
        }
    }
}
