//
//  ImageRenderVC.swift
//  cameraTest
//
//  Created by 성다연 on 16/03/2020.
//  Copyright © 2020 성다연. All rights reserved.
//

import UIKit

class ImageRenderVC: UIViewController {
    @IBOutlet weak var polaroidView: UIView!
    @IBOutlet weak var renderImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    
    // get image from other view
    var image : UIImage?
    var tempsticker : UIImageView?
    var sticker : UIView?
    // value for checkimageview showing while collection cells changes
    fileprivate var isFilterSelected : Bool = true
    fileprivate var testFilterCell : photoFilterCollectionCell?
    fileprivate var testStickerCell : photoStickerCollectionCell?
    fileprivate var testFilterCount = 0, testStickerCount = 0
    // for sticker
    fileprivate var location : CGPoint = CGPoint(x: 0, y: 0)
    fileprivate let stickerArray : [String] = ["heartimage", "starimage", "smileimage"]
    // for filter
    fileprivate let context = CIContext(options: nil)
    fileprivate var filterIndex = 0
    fileprivate var selectIndex : IndexPath?
    fileprivate let filterNameArray : [String] = ["Noise", "Grunge", "Wrap","Light", "Aura", "Old"]
    fileprivate let filterLutArray : [String] = ["LUT", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"]
    // Array for apply LUT filters before viewAppear. And place on collectioncell
    fileprivate var filterImages : [UIImage] = []
    
    
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
        defaultSetting()
    }
}


extension ImageRenderVC {
    private func buttonSetting(){
        filterBtn.addTarget(self, action: #selector(touchFilterBtn), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(touchStickerBtn), for: .touchUpInside)
    }
    
    private func defaultSetting(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        polaroidView.addShadowEffect()
    }
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createStickerView(image : UIImage){
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 3 - 50, width: 100, height: 100)
        imageView.isUserInteractionEnabled = true
        tempsticker = imageView
        createPan(view: imageView)
        self.view.addSubview(imageView)
        
//        let stickerView = StickerLayout(frame: CGRect(x: view.frame.width/2 - 50, y: view.frame.height/3 - 50, width: 100, height: 100))
//        stickerView.isUserInteractionEnabled = true
//        sticker = stickerView
//        print("stickerView = \(stickerView)")
//        createPan(view: stickerView)
//
//        self.polaroidView.addSubview(stickerView)
    }
    
    private func resetCheckImage(){
        if isFilterSelected == true {
            // filter collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: selectIndex!) as! photoFilterCollectionCell
            cell.hideimage()
        } else {
            // sticker collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickercell", for: selectIndex!) as! photoStickerCollectionCell
            cell.hideimage()
        }
    }
}


extension ImageRenderVC {
    @objc func touchFilterBtn(){
        isFilterSelected = true
//        if testStickerCell != nil {
//            testStickerCell?.hideimage()
//            testStickerCell = nil
//        }
        collectionView.reloadData()
    }
    
    @objc func touchStickerBtn(){
        isFilterSelected = false
//        if testFilterCell != nil {
//            testFilterCell?.hideimage()
//            testFilterCell = nil
//        }
        collectionView.reloadData()
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        
        let imageView = panGesture.view as! UIImageView
        imageView.center = CGPoint(x: imageView.center.x + transition.x, y: imageView.center.y + transition.y)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = false
        
        self.polaroidView.addSubview(imageView)
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
        selectIndex = indexPath
        
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
       
        if let cell = collectionView.cellForItem(at: indexPath) as? photoFilterCollectionCell {
            cell.showimage()
            renderImage.image = filterImages[indexPath.row]
            
            testFilterCount += 1
            if testFilterCount <= 1 {
                testFilterCell = cell
            } else {
                testFilterCell?.hideimage()
                testFilterCell = nil
            }
        } else if let cell = collectionView.cellForItem(at: indexPath) as? photoStickerCollectionCell {
            cell.showimage()
            createStickerView(image: UIImage(named: stickerArray[indexPath.row])!)
            
            testStickerCount += 1
            if testStickerCount <= 1 {
                testStickerCell = cell
            } else {
                testStickerCell?.hideimage()
                testStickerCell = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectIndex = indexPath
        
        if let cell = collectionView.cellForItem(at: indexPath) as? photoFilterCollectionCell {
            cell.hideimage()
            testFilterCount = 0
        } else if let cell = collectionView.cellForItem(at: indexPath) as? photoStickerCollectionCell {
            testStickerCount = 0
            cell.hideimage()
        }
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
