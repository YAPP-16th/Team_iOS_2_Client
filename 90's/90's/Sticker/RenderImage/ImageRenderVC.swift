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
//    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var focusView: UIView!
    @IBOutlet weak var renderImage: UIImageView!
    @IBOutlet weak var layoutImage: UIImageView!
    @IBOutlet weak var nameCollectionView: UICollectionView!
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var completeBtn: UIButton!
    @IBAction func cancleBtn(_ sender: UIButton) {
        focusView.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    // get image from other view
    var image : UIImage?
    var photoView : UIView!
    var selectLayout : AlbumLayout! = .Polaroid
    var deviceSize : CGSize = CGSize(width: 0, height: 0)
    // server data
    var albumUid : Int = 0
    var imageName : String = ""

    // for sticker
    var startPosition = CGPoint(x: 0, y: 0)
    var originalWidth = CGFloat(0)
    var widthConstant : NSLayoutConstraint!
    var heightConstant : NSLayoutConstraint!
    fileprivate var sticker : StickerLayout?
    fileprivate var stickerArray : [StickerLayout] = []
    fileprivate var initialAngle = CGFloat(), saveAngle = CGFloat(), saveSize = CGFloat(), initialSize = CGFloat()
    
    // collection data
    fileprivate var isSelectedName : IndexPath = [0,0]
    fileprivate var stickerImages : [UIImage] = StickerImage.Basic.imageArray
    fileprivate let stickerNames : [String] = ["Basic", "Glitter", "Character", "Tape", "Words", "Alphabet", "Number"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in layoutImage.subviews {
            if view is StickerLayout {
                view.removeFromSuperview()
            }
        }
        stickerCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        layoutSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if focusView.isHidden == false {
            if touch?.view == focusView {
                focusView.isHidden = true
            }
        }
      
        if sticker != nil {
            self.initialAngle = pToA(touch!)
            if touch?.view == sticker?.backImageView {
                focusView.isHidden = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        if sticker != nil {
            switch touch!.view {
            case sticker?.resizeImageView :
                let position = touch!.location(in: self.view)
                let previousPosition = touch!.previousLocation(in: self.view)
                let Xdistance = pow(sticker!.center.x - position.x, 2)
                let Ydistance = pow(sticker!.center.y - position.y, 2)
                saveSize = (Xdistance + Ydistance).squareRoot()
                let newWidth = saveSize - initialSize
                print("origin - \(initialSize), change = \(saveSize), re = \(sticker!.resizeImageView.center)")
                
                let ang = pToA(touch!) - initialAngle
                let absoluteAngle = saveAngle + ang
                
                let scale = CGAffineTransform(scaleX: saveSize, y: saveSize)
                let rotate = CGAffineTransform(rotationAngle: absoluteAngle)
                
                saveAngle = absoluteAngle
                sticker?.transform = rotate
                //sticker?.transform = scale.concatenating(rotate)
            case sticker?.cancleImageView :
                sticker?.removeFromSuperview()
                focusView.isHidden = true
                sticker = nil
            default :
                break
            }
        }
    }
}


extension ImageRenderVC {
    private func defaultSetting(){
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.allowsMultipleSelection = false
        nameCollectionView.allowsMultipleSelection = false
        nameCollectionView.dataSource = self
        nameCollectionView.delegate = self
        photoView = layoutImage
        completeBtn.addTarget(self, action: #selector(touchCompleteBtn), for: .touchUpInside)
    }
    
    private func layoutSetting(){
        deviceSize = iPhone8Model() ? selectLayout.deviceLowSize : selectLayout.deviceHighSize
        layoutImage.addSubview(renderImage)
        
        // 레이아웃 크기 조정
        layoutImage = applyBackImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: layoutImage)
        
        // 사진 크기 조정
        renderImage = iPhone8Model() ? applyStickerLowDeviceImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: renderImage, image: image!) : applyStickerHighDeviceImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: renderImage, image: image!)

        // 뷰 위치 조정
        setRenderSaveViewFrameSetting(view: layoutImage, selectLayout: selectLayout, size: deviceSize)
        //setRenderLayoutViewFrameSetting(view: view, imageView: layoutImage, top: 0, left: 0, right: 0, bottom: 0)
    }
    
    private func resetValues(){
        sticker = nil
        stickerArray = []
        saveAngle = CGFloat()
        saveSize = CGFloat()
        focusView.isHidden = true
        stickerCollectionView.reloadData()
    }
    
    private func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: sticker)
        let c = sticker!.convert(sticker!.center, from:sticker!.superview!)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
  
    private func createGesture(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(rotateGesture:)))
        
        panGesture.maximumNumberOfTouches = 1
        
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(rotateGesture)
    }
    
    private func createStickerView(image : UIImage, indexPathRow : Int){
        sticker = StickerLayout.loadFromZib(image: image)
        sticker!.frame.size = CGSize(width: 120, height: 120)
        sticker!.center = CGPoint(x: view.center.x - 30, y: view.center.y - 200)
        createGesture(view: sticker!.backImageView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleResizePanGesture(panGesture:)))
        sticker?.resizeImageView.addGestureRecognizer(pan)
        focusView.isHidden = false
        self.layoutImage.addSubview(sticker!)
        widthConstant = sticker!.widthAnchor.constraint(equalToConstant: 120)
        widthConstant.isActive = true
        heightConstant = sticker!.heightAnchor.constraint(equalToConstant: 120)
        heightConstant.isActive = true
        let Xdistance = pow(sticker!.center.x - sticker!.resizeImageView.center.x, 2)
        let Ydistance = pow(sticker!.center.y - sticker!.resizeImageView.center.y, 2)
        initialSize = (Xdistance + Ydistance).squareRoot()
        stickerArray.append(sticker!)
    }
    
    private func goToNextVC(image : UIImage){
        resetValues()
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "savePhotoVC") as! SavePhotoVC
               
        nextVC.originImage = image
        nextVC.selectedLayout = selectLayout
        nextVC.albumUid = albumUid
        nextVC.imageName = imageName
        nextVC.deviceSize = deviceSize
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension ImageRenderVC {
    @objc private func touchCompleteBtn(){
        for views in layoutImage.subviews {
            if views is StickerLayout {
                (views as! StickerLayout).cancleImageView.isHidden = true
                (views as! StickerLayout).resizeImageView.isHidden = true
            }
        }
        
        let renderer = UIGraphicsImageRenderer(size: layoutImage.bounds.size)
        let renderImage = renderer.image { ctx in
            layoutImage.drawHierarchy(in: layoutImage.bounds, afterScreenUpdates: true)
        }
        
        goToNextVC(image: renderImage)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Image saved")
        }
    }
    
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transition = panGesture.translation(in: sticker)
        sticker!.center = CGPoint(x: sticker!.center.x + transition.x, y: sticker!.center.y + transition.y)
        panGesture.setTranslation(CGPoint.zero, in: sticker)
    }
    
    @objc private func handleResizePanGesture(panGesture : UIPanGestureRecognizer){
        if panGesture.state == .began {
            startPosition = panGesture.location(in: self.view)
            originalWidth = widthConstant.constant
        }
        if panGesture.state == .changed {
            let endPosition = panGesture.location(in: self.view)
            let diff = max(startPosition.x - endPosition.x, startPosition.y - endPosition.y)
            let newWidth = originalWidth - diff
            
            widthConstant.constant = newWidth
        }
    }
    
    @objc private func handlePinchGesture(pinchGesture : UIPinchGestureRecognizer){
        sticker!.transform = (sticker!.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale))
        saveSize = pinchGesture.scale
        pinchGesture.scale = 1.0
    }
    
    @objc private func handleRotateGesture(rotateGesture : UIRotationGestureRecognizer){
        sticker!.transform = sticker!.transform.rotated(by: rotateGesture.rotation)
        saveAngle = rotateGesture.rotation
        rotateGesture.rotation = 0
    }
}


extension ImageRenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.nameCollectionView ? stickerNames.count : stickerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.nameCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerHeaderCell", for: indexPath) as! StickerHeaderCell
            cell.label.text = stickerNames[indexPath.row]
            cell.label.textColor = .lightGray
            if isSelectedName == indexPath {
                cell.label.textColor = .black
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! photoStickerCollectionCell
            cell.imageView.image = stickerImages[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == self.nameCollectionView ? CGSize(width: 84, height: 40) : CGSize(width: 84, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.nameCollectionView ? 1.0 : 7.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.nameCollectionView {
            isSelectedName = indexPath
            stickerImages = StickerDatabase.arrayList[indexPath.row].imageArray
            nameCollectionView.reloadData()
            stickerCollectionView.reloadData()
        } else {
            createStickerView(image: stickerImages[indexPath.row], indexPathRow: indexPath.row)
        }
    }
}


class StickerHeaderCell: UICollectionViewCell {
    @IBOutlet weak var label : UILabel!
}


class photoStickerCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 40
    }
}
