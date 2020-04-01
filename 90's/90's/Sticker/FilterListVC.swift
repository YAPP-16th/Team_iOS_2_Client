//
//  FilterListVC.swift
//  AlbumExample
//
//  Created by 성다연 on 24/03/2020.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit
import Photos

class FilterListVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    fileprivate var filterIndex = 0
    fileprivate let context = CIContext(options: nil)
    fileprivate var smallImage: UIImage?
    
    var image : UIImage? // get image from MainVC
    fileprivate let filterList = [ "filter_lut_1", "filter_lut_2", "filter_lut_3", "filter_lut_4"]
    fileprivate let filterName = [ "Lut 1", "Lut 2", "Lut 3", "Lut 4"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        smallImage = image //resizeImage(image: image!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        collectionSetting()
    }

}


extension FilterListVC {
    func applyFilter() {
            imageView.image = applyLUTImage(filename: filterList[filterIndex])
    }
        
    func applyLUTImage(filename: String) -> UIImage{
        let test = colorCubeFilterFromLUT(imageName: filterList[filterIndex], originalImage: image!)
        let result = test?.outputImage
        let image = UIImage.init(cgImage: context.createCGImage(result!, from: result!.extent)!)
        
        return image
    }
}


extension FilterListVC {
    func collectionSetting(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
       
    func buttonSetting(){
        saveBtn.addTarget(self, action: #selector(touchSaveBtn), for: .touchUpInside)
        cancleBtn.addTarget(self, action: #selector(touchCancleBtn), for: .touchUpInside)
    }
       
    @objc func touchSaveBtn(){
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let image = renderer.image { ctx in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
       
    @objc func touchCancleBtn(){
        dismiss(animated: true, completion: nil)
    }
}


extension FilterListVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        var tempImage = smallImage
        if indexPath.row != 0 {
            tempImage = applyLUTImage(filename: filterList[indexPath.row])//createFilteredImage(filterName: filterList[indexPath.row], image: smallImage!)
        }
           
        cell.imageView.image = tempImage
        cell.imageLabel.text = filterName[indexPath.row]
        updateCellFont()
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterIndex = indexPath.row
        if filterIndex != 0 {
            applyFilter()
        } else {
            imageView?.image = image
        }
           
        updateCellFont()
        scrollCollectionViewToIndex(itemIndex: indexPath.item)
    }
       
    func updateCellFont(){
        if let selectedCell = collectionView?.cellForItem(at: IndexPath(row: filterIndex, section: 0)) {
            let cell = selectedCell as! ImageCollectionViewCell
            cell.imageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        }
              
        for i in 0...filterList.count-1 {
            if i != filterIndex {
                if let unselectedCell = collectionView?.cellForItem(at: IndexPath(row: i, section: 0)) {
                    let cell = unselectedCell as! ImageCollectionViewCell
                       
                    if #available(iOS 8.2, *){
                        cell.imageLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .thin)
                    } else {
                        cell.imageLabel.font = UIFont.systemFont(ofSize: 15.0)
                    }
                }
            }
        }
    }
       
    func scrollCollectionViewToIndex(itemIndex : Int){
        let indexPath = IndexPath(item: itemIndex, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
