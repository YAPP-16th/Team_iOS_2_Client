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
    var tempsticker : UIImageView?
    var selectLayout : AlbumLayout! = .Polaroid
    // server data
    var albumUid : Int?
    var imageName : String?
    
    // value for checkimageview showing while collection cells changes
    fileprivate var isFilterSelected : Bool = true
    fileprivate var testFilterCell : photoFilterCollectionCell?
    fileprivate var testStickerCell : photoStickerCollectionCell?
    fileprivate var testFilterCount = 0, testStickerCount = 0
    // for sticker
    fileprivate var sticker : StickerLayout?
    fileprivate var initialAngle = CGFloat(), angle = CGFloat(), saveSize = CGFloat()
    fileprivate var location : CGPoint = CGPoint(x: 0, y: 0), savePosition : CGPoint = CGPoint(x: 0, y: 0)
    fileprivate let stickerArray : [String] = ["heartimage", "starimage", "smileimage"]
    // for filter
    fileprivate let context = CIContext(options: nil)
    fileprivate var filterIndex = 0
    fileprivate var selectIndex : IndexPath?
    fileprivate let filterNameArray : [String] = ["Noise", "Grunge", "Wrap", "Light", "Aura", "Old"]
    fileprivate let filterLutArray : [String] = ["LUT", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"]
    // Array for apply LUT filters & Sticker before viewAppear. And place on collectioncell
    fileprivate var filterImages : [UIImage] = [], stickerImages : [UIImage] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
        defaultSetting()
        setSaveViewLayout(view: saveView, selectLayout: selectLayout)
        setRenderImageViewLayout()
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
        renderImage.image = image
        photoView = saveView
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
        sticker?.center = view.center
        createPan(view: sticker!.backImageView) // 이미지 옮기기
        self.view.addSubview(sticker!)
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
    
    private func setRenderImageViewLayout(){
        let size = returnLayoutBigSize(selectedLayout: selectLayout)
        layoutImage = applyBackImageViewLayout(selectedLayout: selectLayout, smallBig: size, imageView: layoutImage)
        renderImage = applyImageViewLayout(selectedLayout: selectLayout, smallBig: size, imageView: renderImage, image: image!)
        view.layoutIfNeeded()
    }
    
    func createnewimage() -> UIImage{
        let render = UIGraphicsImageRenderer(size: (sticker?.frame.size)!)
        let position = CGPoint(x: savePosition.x - saveView.frame.origin.x, y: savePosition.y - saveView.frame.origin.y)
        let returnimage = render.image(actions: { _ in
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: position.x, y: position.y)
            context?.rotate(by: angle)
            context?.draw((image?.cgImage!)!, in: CGRect(origin: CGPoint(x: position.x, y: position.y), size: (sticker?.frame.size)!))
        })
        return returnimage
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
        if sticker != nil {
            let takeStickerImageView = sticker?.stickerImageView
            takeStickerImageView?.center = sticker!.center
            takeStickerImageView?.image = createnewimage()
            takeStickerImageView?.translatesAutoresizingMaskIntoConstraints = false
            saveView.addSubview(takeStickerImageView!)
//            let position = CGPoint(x: savePosition.x - saveView.frame.origin.x, y: savePosition.y - saveView.frame.origin.y)
//
//            takeStickerImageView?.transform = CGAffineTransform(scaleX: saveSize, y: saveSize).concatenating(CGAffineTransform(rotationAngle: angle)).concatenating(CGAffineTransform(translationX: position.x, y: position.y))
            sticker?.removeFromSuperview()
            sticker = nil
        }
        
        
        print("ImageRenderVC saveview frame = \(saveView.frame)")
        photoImage = saveView.createImage()
        angle = CGFloat()
        saveSize = CGFloat()
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "savePhotoVC") as! SavePhotoVC
        nextVC.photoView = photoView
        nextVC.originImage = photoImage
        nextVC.selectedLayout = selectLayout
        nextVC.albumUid = albumUid
        nextVC.imageName = imageName
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
                stickerBtn.isEnabled = false
                filterBtn.isEnabled = true
            } else {
                testStickerCell?.hideimage()
                testStickerCell = nil
                stickerBtn.isEnabled = true
                filterBtn.isEnabled = false
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
