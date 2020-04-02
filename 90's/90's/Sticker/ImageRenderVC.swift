//
//  ImageRenderVC.swift
//  cameraTest
//
//  Created by 성다연 on 16/03/2020.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class ImageRenderVC: UIViewController {
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
    fileprivate let filterArray : [String] = ["LUT", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"]
    
    fileprivate var isFilterSelected : Bool = true
    fileprivate var filterImages : [UIImage] = []// Array for apply LUT filters before viewAppear. And place on collectioncell
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // test
        if image == nil {
            image = UIImage(named: "husky")
        }
        renderImage.image = image
        
        filterImages = filterArray.map({ (v : String) -> UIImage in
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
//        let touch : UITouch! = touches.first! as UITouch
//        location = touch.location(in: view)
//
//        if sticker1.frame.contains(location) {
//            sticker1.center = location
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch : UITouch! = touches.first! as UITouch
//        location = touch.location(in: view)
//
//        if sticker1.frame.contains(location) {
//            sticker1.center = location
//        }
//    }
}


extension ImageRenderVC {
    private func buttonSetting(){
        filterBtn.addTarget(self, action: #selector(touchFilterBtn), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(touchStickerBtn), for: .touchUpInside)
    }
    
    private func delegateSetting(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
//    private func stickerSetting(){
//        let imageView1 = UIImageView(image: UIImage(named: "starimage")!)
//        imageView1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        sticker1.addSubview(imageView1)
//    }
    

//    private func renderViewAsImage(){
////        if polaroidView.frame.contains(sticker1.frame) {
////            sticker1.bounds.origin.y = 49
////            polaroidView.addSubview(sticker1)
////        }
//
//        let renderer = UIGraphicsImageRenderer(size: renderImage.bounds.size)
//        let image = renderer.image { ctx in
//            renderImage.drawHierarchy(in: renderImage.bounds, afterScreenUpdates: true)
//        }
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
}


extension ImageRenderVC {
    @objc func touchFilterBtn(){
        
    }
    
    @objc func touchStickerBtn(){
        
    }
}



extension ImageRenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! photoFilterCollectionCell
        cell.imageView.image = filterImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 73, height: 88)
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
}


extension ImageRenderVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToSaveVC" {
            let dest = segue.destination as? SavePhotoVC
            dest?.image = image
            print("send segue")
        }
    }
}
