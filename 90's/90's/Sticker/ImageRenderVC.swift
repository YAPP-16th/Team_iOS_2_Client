//
//  ImageRenderVC.swift
//  cameraTest
//
//  Created by 성다연 on 16/03/2020.
//  Copyright © 2020 성다연. All rights reserved.
//
import UIKit

class ImageRenderVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var renderImage: UIImageView!
    @IBOutlet weak var layoutImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBAction func cancleBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // get image from other view
    var image : UIImage?
    var photoView : UIView!
    var photoImage : UIImage?
    var selectLayout : AlbumLayout! = .Polaroid
    var deviceSize : CGSize = CGSize(width: 0, height: 0)
    // server data
    var albumUid : Int = 0
    var imageName : String = ""
    
    // value for checkimageview showing while collection cells changes
    fileprivate var isFilterSelected : Bool = true

    // for sticker
    fileprivate var sticker : StickerLayout?
    fileprivate var initialAngle = CGFloat(), angle = CGFloat(), saveSize = CGFloat()
    fileprivate var savePosition : CGPoint = CGPoint(x: 0, y: 0)
    fileprivate let stickerArray : [String] = ["heartimage", "starimage", "smileimage"]
    // for filter
    fileprivate let context = CIContext(options: nil)
    
    fileprivate let filterStruct = PhotoEditorTypes()
    fileprivate var filterIndex = 0
    fileprivate var selectIndex : IndexPath?
    
    fileprivate var filterImages : [UIImage] = [], stickerImages : [UIImage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        defaultSetting()
        initializeArrays()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sticker != nil {
            self.initialAngle = pToA(touches.first!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if sticker != nil {
            switch touch!.view {
            case sticker?.rotateImageView :
                let ang = pToA(touch!) - self.initialAngle
                let absoluteAngle = self.angle + ang
                sticker?.transform = (sticker?.transform.rotated(by: ang))!
                self.angle = absoluteAngle
                
            case sticker?.resizeImageView :
                let position = touch!.location(in: self.view)
                let target = sticker?.center
                let size = max((position.x / target!.x), (position.y / target!.y))
                let scale = CGAffineTransform(scaleX: size, y: size)
                let rotate = CGAffineTransform(rotationAngle: angle)
                saveSize = size
                sticker?.transform = scale.concatenating(rotate)
                
            case sticker?.cancleImageView :
                sticker?.removeFromSuperview()
                sticker = nil
            default :
                break
            }
        }
    }
}


extension ImageRenderVC {
    private func buttonSetting(){
        filterBtn.addTarget(self, action: #selector(touchFilterBtn), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(touchStickerBtn), for: .touchUpInside)
        completeBtn.addTarget(self, action: #selector(touchCompleteBtn), for: .touchUpInside)
    }
    
    private func defaultSetting(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        photoView = saveView
    }
    
    private func initializeArrays(){
        deviceSize = isDeviseVersionLow ? returnLayoutSize(selectedLayout: selectLayout) : returnLayoutBigSize(selectedLayout: selectLayout)
        
        let size = returnLayoutBigSize(selectedLayout: selectLayout)
        layoutImage = applyBackImageViewLayout(selectedLayout: selectLayout, smallBig: size, imageView: layoutImage)
        renderImage = applyImageViewLayout(selectedLayout: selectLayout, smallBig: size, imageView: renderImage, image: image!)
        
        setRenderLayoutViewFrameSetting(view: saveView, imageView: layoutImage)
        setRenderImageViewFrameSetting(view: saveView, imageView: renderImage, selectlayout: selectLayout)
        
        view.layoutIfNeeded()
        
        filterImages = PhotoEditorTypes.filterImage.map({ (v : String) -> UIImage in
            return UIImage(named: v)!
        })
        stickerImages = stickerArray.map({ ( v : String ) -> UIImage in
            return UIImage(named: v)!
        })
    }
    
    private func resetValues(){
        angle = CGFloat()
        saveSize = CGFloat()
        collectionView.reloadData()
    }
    
    private func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: sticker)
        let c = sticker!.convert(sticker!.center, from:sticker!.superview!)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createStickerView(image : UIImage, indexPathRow : Int){
        sticker = StickerLayout.loadFromZib(image: image)
        sticker?.frame.size = CGSize(width: 120, height: 120)
        sticker?.center = saveView.center
        createPan(view: sticker!.backImageView) // 이미지 옮기기
        self.saveView.addSubview(sticker!)
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
    
    @objc func touchCompleteBtn(){
        for views in saveView.subviews {
            if(views is StickerLayout){
                (views as! StickerLayout).cancleImageView.isHidden = true
                (views as! StickerLayout).rotateImageView.isHidden = true
                (views as! StickerLayout).resizeImageView.isHidden = true
                (views as! StickerLayout).backImageView.isHidden = true
            }
        }
        
        let renderer = UIGraphicsImageRenderer(size: saveView.bounds.size)
        let renderImage = renderer.image { ctx in
            saveView.drawHierarchy(in: saveView.bounds, afterScreenUpdates: true)
        }
        
        resetValues()
        if selectIndex != nil {
            collectionView.deselectItem(at: selectIndex!, animated: false)
        }
        print("imageRenderVC - renderImage = \(renderImage)")
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "savePhotoVC") as! SavePhotoVC
        
        nextVC.originImage = renderImage
        nextVC.selectedLayout = selectLayout
        nextVC.albumUid = albumUid
        nextVC.imageName = imageName
        nextVC.deviceSize = deviceSize
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        /// todo : 팬에 기울기도 적용하기
        panGesture.setTranslation(CGPoint.zero, in: sticker)
        if sticker != nil {
            sticker!.center = CGPoint(x: sticker!.center.x + transition.x, y: sticker!.center.y + transition.y)
            savePosition = sticker!.frame.origin
        }
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
            return cell
        } else {
            // sticker collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickercell", for: indexPath) as! photoStickerCollectionCell
            cell.imageView.image = stickerImages[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isFilterSelected == true {
            return CGSize(width: 74, height: 88)
        } else {
            return CGSize(width: 85, height: 88)
        }
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
            cell.hideimage(value: false)
            let colorcube = colorCubeFilterFromLUT(imageName: PhotoEditorTypes.filterNameArray[indexPath.row], originalImage: image!)
            let image = UIImage.init(cgImage: context.createCGImage((colorcube?.outputImage)!, from: (colorcube?.outputImage)!.extent)!)
            
            renderImage.image = image
            stickerBtn.titleLabel?.textColor = .lightGray
            filterBtn.titleLabel?.textColor = .black
            isFilterSelected = true
            
        } else if let cell = collectionView.cellForItem(at: indexPath) as? photoStickerCollectionCell {
            cell.hideimage(value: false)
            createStickerView(image: stickerImages[indexPath.row], indexPathRow: indexPath.row)
            
            stickerBtn.titleLabel?.textColor = .black
            filterBtn.titleLabel?.textColor = .lightGray
            isFilterSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectIndex = indexPath

        if let cell = collectionView.cellForItem(at: indexPath) as? photoFilterCollectionCell {
            cell.hideimage(value: true)
        } else if let cell = collectionView.cellForItem(at: indexPath) as? photoStickerCollectionCell {
            cell.hideimage(value: true)
        }
    }
}
