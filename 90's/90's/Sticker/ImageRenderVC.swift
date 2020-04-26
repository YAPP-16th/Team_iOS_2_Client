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
    var isStickerRotateClicked : Bool = false
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
    // Array for apply LUT filters & Sticker before viewAppear. And place on collectioncell
    fileprivate var filterImages : [UIImage] = []
    fileprivate var stickerImages : [UIImage] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil {
            image = UIImage(named: "husky")!
        }
        
        collectionView.reloadData()
        renderImage.image = image
        initializeArrays()
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
    
    private func initializeArrays(){
        filterImages = filterLutArray.map({ (v : String) -> UIImage in
            let colorcube = colorCubeFilterFromLUT(imageName: v, originalImage: image!)
            let result = colorcube?.outputImage
            let image = UIImage.init(cgImage: context.createCGImage(result!, from: result!.extent)!)
            return image
        })
        stickerImages = stickerArray.map({ ( v : String ) -> UIImage in
            return UIImage(named: v)!
        })
    }
    
    private func createPan(view : UIView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
//    private func createRotate(view : UIView){
//        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotateGesture(rotateGesture:)))
//        view.addGestureRecognizer(rotateGesture)
//    }
    
    private func createTap(view : UIView){
        let tapGestue = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(tapGestrue:)))
        view.addGestureRecognizer(tapGestue)
    }
    
    private func createStickerView(image : UIImage, indexPathRow : Int){
        let stickerView = Bundle.main.loadNibNamed("StickerLayout", owner: nil, options: nil)?.first as! StickerLayout
        stickerView.frame = CGRect(x: view.frame.width/2 - 50, y: view.frame.height/3 - 50, width: 100, height: 100)
        stickerView.stickerImageView.image = stickerImages[indexPathRow]
        stickerView.isUserInteractionEnabled = true
        sticker = stickerView
        
        createPan(view: stickerView) // 이미지 옮기기
        //createRotate(view: stickerView)
        //createTap(view: stickerView)

        self.view.addSubview(stickerView)
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
        collectionView.reloadData()
    }
    
    @objc func touchStickerBtn(){
        isFilterSelected = false
        collectionView.reloadData()
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        
        let imageView = panGesture.view as! StickerLayout
        imageView.center = CGPoint(x: imageView.center.x + transition.x, y: imageView.center.y + transition.y)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = false
    }
    
    @objc func handleRotateGesture(rotateGesture : UIRotationGestureRecognizer){
        sticker!.layer.anchorPoint = CGPoint(x: sticker!.center.x, y: sticker!.center.y)
        sticker!.transform = sticker!.transform.rotated(by: rotateGesture.rotation)
        
        rotateGesture.rotation = 0
        print("rotate gesture working")
    }
    
    @objc func handleTapGesture(tapGestrue : UITapGestureRecognizer){
        if tapGestrue.state == .changed {
            let point = tapGestrue.location(in: tapGestrue.view)
            
        }
    }
    
    @objc func handlePinGesture(pinGesture : UIPinchGestureRecognizer){
        sticker!.transform = sticker!.transform.scaledBy(x: pinGesture.scale, y: pinGesture.scale)
        pinGesture.scale = 1.0
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
            cell.imageView.image = stickerImages[indexPath.row]
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
            createStickerView(image: stickerImages[indexPath.row], indexPathRow: indexPath.row)
            
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
    func isRotateBtnClicked(){
        isStickerRotateClicked = !isStickerRotateClicked
        print("isClicked = \(isStickerRotateClicked)")
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


