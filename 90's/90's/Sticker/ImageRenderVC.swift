//
//  ImageRenderVC.swift
//  cameraTest
//
//  Created by 성다연 on 16/03/2020.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class ImageRenderVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var polaroidView: UIView!
    @IBOutlet weak var renderImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    
    // get image from other view
    var image : UIImage?
    // for sticker
    fileprivate var location : CGPoint = CGPoint(x: 0, y: 0)
    fileprivate let stickerArray : [String] = ["heartimage", "starimage", "smileimage"]
    // for filter
    fileprivate let context = CIContext(options: nil)
    fileprivate var filterIndex = 0
    fileprivate var selectIndex : IndexPath?
    fileprivate let filterNameArray : [String] = ["Noise", "Grunge", "Wrap","Light", "Aura", "Old"]
    fileprivate let filterLutArray : [String] = ["LUT", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"]
    
    fileprivate var isFilterSelected : Bool = true
    fileprivate var filterImages : [UIImage] = []// Array for apply LUT filters before viewAppear. And place on collectioncell
    fileprivate var pan : UIPanGestureRecognizer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        if image == nil { // for test
            image = UIImage(named: "husky")
        }
        
        renderImage.image = image
        
        filterImages = filterLutArray.map({ (v : String) -> UIImage in
            let colorcube = colorCubeFilterFromLUT(imageName: v, originalImage: image!)
            let result = colorcube?.outputImage
            let image = UIImage.init(cgImage: context.createCGImage(result!, from: result!.extent)!)
            return image
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        delegateSetting()
    }
}


extension ImageRenderVC {
    private func buttonSetting(){
        filterBtn.addTarget(self, action: #selector(touchFilterBtn), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(touchStickerBtn), for: .touchUpInside)
    }
    
    private func delegateSetting(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
    }
    
    private func createStickerView(image : UIImage){
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: self.renderImage.frame.width / 2 - 50, y:renderImage.frame.height / 2 - 50, width: 100, height: 100)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pan!)
        renderImage.addSubview(imageView)
    }
}


extension ImageRenderVC {
    @objc func touchFilterBtn(){
        isFilterSelected = true
        collectionView.reloadData()
    }
    
    @objc func touchStickerBtn(){
        isFilterSelected = false
        collectionView.reloadData()
    }
}


extension ImageRenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFilterSelected == true {   // filter collection
            return filterImages.count
        } else {                        // sticker collection
            return stickerArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isFilterSelected == true {
            // filter collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! photoFilterCollectionCell
            cell.imageView.image = filterImages[indexPath.row]
            cell.filterLabel.text = filterNameArray[indexPath.row]
            return cell
        } else {
            // sticker collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickercell", for: indexPath) as! photoStickerCollectionCell
            cell.imageView.image = UIImage(named: stickerArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath
        
        if isFilterSelected == true {
            // filter collection
            let cell = collectionView.cellForItem(at: indexPath) as! photoFilterCollectionCell
            renderImage.image = filterImages[indexPath.row]
            cell.checkImageView.isHidden = false
        } else {
            // sticker collection
            let cell = collectionView.cellForItem(at: indexPath) as! photoStickerCollectionCell
            cell.imageView.image = UIImage(named: stickerArray[indexPath.row])
            cell.checkImageView.isHidden = false
        }
        print("collection select = \(collectionView.indexPathsForSelectedItems)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectIndex = indexPath
        
        if isFilterSelected == true {
            // filter collection
            let cell = collectionView.cellForItem(at: indexPath) as! photoFilterCollectionCell
            cell.checkImageView.isHidden = true
        } else {
            // sticker collection
            let cell = collectionView.cellForItem(at: indexPath) as! photoStickerCollectionCell
            cell.checkImageView.isHidden = true
        }
        
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension ImageRenderVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToSaveVC" {
            let dest = segue.destination as? SavePhotoVC
            dest?.image = renderImage.image
            dest?.originalView = polaroidView
            
            print("send segue")
        }
    }
}
