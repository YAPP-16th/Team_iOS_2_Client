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
        var size : CGSize = CGSize(width: 0, height: 0)
        
        switch selectedLayout {
        case .Polaroid :
            cell.backimageView.image = AlbumLayout.Polaroid.image
            cell.backimageView.frame.size = AlbumLayout.Polaroid.size
            size = CGSize(width: AlbumLayout.Polaroid.size.width - 20, height: AlbumLayout.Polaroid.size.height - 50)
            cell.imageView.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
        case .Mini :
            cell.backimageView.image = AlbumLayout.Mini.image
            cell.backimageView.frame.size = AlbumLayout.Mini.size
            size = CGSize(width: AlbumLayout.Mini.size.width - 24, height: AlbumLayout.Mini.size.height - 48)
            cell.imageView.frame = CGRect(x: 12, y: 9, width: size.width, height: size.height)
        case .Memory :
            cell.backimageView.image = AlbumLayout.Memory.image
            cell.backimageView.frame.size = AlbumLayout.Memory.size
            size = CGSize(width: AlbumLayout.Memory.size.width - 48, height: AlbumLayout.Memory.size.height - 52)
            cell.imageView.frame = CGRect(x: 24, y: 26, width: size.width, height: size.height)
        case .Portrab :
            cell.backimageView.image = AlbumLayout.Portrab.image
            cell.backimageView.frame.size = AlbumLayout.Portrab.size
            size = CGSize(width: AlbumLayout.Portrab.size.width - 20, height: AlbumLayout.Portrab.size.height - 24)
            cell.imageView.frame = CGRect(x: 10, y: 12, width: size.width, height: size.height)
        case .Tape :
            cell.backimageView.image = AlbumLayout.Tape.image
            cell.backimageView.frame.size = AlbumLayout.Tape.size
            size = CGSize(width: AlbumLayout.Tape.size.width - 44, height: AlbumLayout.Tape.size.height - 80)
            cell.imageView.frame = CGRect(x: 23, y: 43, width: size.width, height: size.height)
        case .Portraw :
            cell.backimageView.image = AlbumLayout.Portraw.image
            cell.backimageView.frame.size = AlbumLayout.Portraw.size
            size = CGSize(width: AlbumLayout.Portraw.size.width - 18, height: AlbumLayout.Portraw.size.height - 30)
            cell.imageView.frame = CGRect(x: 9, y: 15, width: size.width, height: size.height)
        case .Filmroll :
            // 이미지 없어서 건너뜀
            cell.backimageView.image = AlbumLayout.Filmroll.image
            cell.backimageView.frame.size = AlbumLayout.Filmroll.size
            cell.imageView.frame = CGRect(x: 20, y: 2, width: AlbumLayout.Filmroll.size.width - 40, height: AlbumLayout.Filmroll.size.height - 4)
        default: cell.backimageView.image = AlbumLayout.Polaroid.image
        }
        
        cell.imageView.image = photoArray[indexPath.row].imageResize(sizeChange: size)
        print("contentview size = \(cell.contentView.frame)")
        print("imageview size = \(cell.imageView.frame) image size = \(cell.imageView.image?.size)")

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
