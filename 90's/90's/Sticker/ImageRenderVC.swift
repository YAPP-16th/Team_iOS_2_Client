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
    fileprivate var sticker : StickerLayout?
    fileprivate var stickerArray : [StickerLayout] = []
    fileprivate var initialAngle = CGFloat(), saveAngle = CGFloat(), saveSize = CGFloat()
    
    // collection data
    fileprivate var isSelectedName : IndexPath = [0,0]
    fileprivate var stickerImages : [UIImage] = StickerImage.Basic.imageArray
    fileprivate let stickerNames : [String] = ["Basic", "Glitter", "Character", "Tape", "Words", "Alphabet", "Number"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in saveView.subviews {
            if view is StickerLayout {
                view.removeFromSuperview()
            }
        }
        stickerCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetting()
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
            case sticker?.rotateImageView :
                let ang = pToA(touch!) - initialAngle
                let absoluteAngle = saveAngle + ang
                sticker?.transform = (sticker?.transform.rotated(by: ang))!
                saveAngle = absoluteAngle
            case sticker?.resizeImageView :
                let position = touch!.location(in: self.view)
                let target = sticker?.center
                let size = max((position.x / target!.x), (position.y / target!.y))
                let scale = CGAffineTransform(scaleX: size, y: size)
                let rotate = CGAffineTransform(rotationAngle: saveAngle)
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
        completeBtn.addTarget(self, action: #selector(touchCompleteBtn), for: .touchUpInside)
    }
    
    private func defaultSetting(){
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.allowsMultipleSelection = false
        nameCollectionView.allowsMultipleSelection = false
        nameCollectionView.dataSource = self
        nameCollectionView.delegate = self
        photoView = saveView
    }
    
    private func layoutSetting(){
        deviceSize = iPhone8Model() ?
            returnLayoutStickerLowDeviceSize(selectedLayout: selectLayout) :
            returnLayoutStickerHighDeviceSize(selectedLayout: selectLayout)
        
        // 레이아웃 크기 조정
        layoutImage = applyBackImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: layoutImage)
        
        // 사진 크기 조정
        renderImage = iPhone8Model() ?
            applyStickerLowDeviceImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: renderImage, image: image!) :
            applyStickerHighDeviceImageViewLayout(selectedLayout: selectLayout, smallBig: deviceSize, imageView: renderImage, image: image!)

        // 뷰 위치 조정
        setRenderSaveViewFrameSetting(view: saveView, selectLayout: selectLayout, size: deviceSize)
        setRenderLayoutViewFrameSetting(view: saveView, imageView: layoutImage)
        setRenderImageViewFrameSetting(view: saveView, imageView: renderImage, selectlayout: selectLayout)
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
    
    private func createPan(view : UIImageView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(panGesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func createStickerView(image : UIImage, indexPathRow : Int){
        sticker = StickerLayout.loadFromZib(image: image)
        sticker?.frame.size = CGSize(width: 120, height: 120)
        sticker?.center = CGPoint(x: saveView.center.x - 30, y: saveView.center.y - 200)
        createPan(view: sticker!.backImageView) // 이미지 옮기기
        focusView.isHidden = false
        self.saveView.addSubview(sticker!)
        stickerArray.append(sticker!)
    }
}


extension ImageRenderVC {
    @objc func touchCompleteBtn(){
        for views in saveView.subviews {
            print("view = \(views)")
            if(views is StickerLayout){
                (views as! StickerLayout).cancleImageView.isHidden = true
                (views as! StickerLayout).rotateImageView.isHidden = true
                (views as! StickerLayout).resizeImageView.isHidden = true
            }
        }
        
        let renderer = UIGraphicsImageRenderer(size: saveView.bounds.size)
        let renderImage = renderer.image { ctx in
            saveView.drawHierarchy(in: saveView.bounds, afterScreenUpdates: true)
        }
        
        resetValues()
      
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
        /// todo : 팬에 기울기도 적용하기
        if sticker != nil {
            let transition = panGesture.translation(in: sticker)
            let scale = CGAffineTransform(scaleX: saveSize, y: saveSize)
            let rotate = CGAffineTransform(rotationAngle: saveAngle)
            
            sticker!.center = CGPoint(x: sticker!.center.x + transition.x, y: sticker!.center.y + transition.y)
            panGesture.setTranslation(CGPoint.zero, in: sticker)
            
        }
    }
}


extension ImageRenderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.nameCollectionView {
            return stickerNames.count
        } else {
            return stickerImages.count
        }
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
        if collectionView == self.nameCollectionView {
            return CGSize(width: 84, height: 40)
        } else {
            return CGSize(width: 84, height: 84)
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
        if collectionView == self.nameCollectionView {
            return 1.0
        } else {
            return 7.0
        }
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
