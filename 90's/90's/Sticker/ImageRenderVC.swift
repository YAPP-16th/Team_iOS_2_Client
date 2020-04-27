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
    // sticker
    var sticker : StickerLayout?
    var initialAngle = CGFloat()
    var angle = CGFloat()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.initialAngle = pToA(touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch!.view == sticker?.rotateImageView {
            let ang = pToA(touch!) - self.initialAngle
            let absoluteAngle = self.angle + ang
            sticker?.transform = (sticker?.transform.rotated(by: ang))!
            self.angle = absoluteAngle
        }
        else if touch!.view == sticker?.resizeImageView {
            let position = touch!.location(in: self.view)
            let target = sticker?.center
            
            let size = max((position.x / target!.x), (position.y / target!.y))
            let scale = CGAffineTransform(scaleX: size, y: size)
            let rotate = CGAffineTransform(rotationAngle: angle)
            sticker?.transform = scale.concatenating(rotate)
        }
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
    
    func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: sticker)
        let c = sticker!.convert(sticker!.center, from:sticker!.superview!)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createStickerView(image : UIImage, indexPathRow : Int){
        let stickerView = Bundle.main.loadNibNamed("StickerLayout", owner: self, options: nil)?.first as! StickerLayout
        stickerView.frame = CGRect(x: view.frame.width/2 - 70, y: view.frame.height/2 - 100, width: 140, height: 140)
        stickerView.stickerImageView.image = stickerImages[indexPathRow]
        stickerView.isUserInteractionEnabled = true
        sticker = stickerView
        
        createPan(view: stickerView.backImageView) // 이미지 옮기기

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
        sticker!.center = CGPoint(x: sticker!.center.x + transition.x, y: sticker!.center.y + transition.y)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToSaveVC" {
            let dest = segue.destination as? SavePhotoVC
            dest?.image = renderImage.image
            dest?.originalView = polaroidView
            print("send segue")
        }
    }
}


