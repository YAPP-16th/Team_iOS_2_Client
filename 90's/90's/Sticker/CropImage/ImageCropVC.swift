//
//  ImageCropVC.swift
//  90's
//
//  Created by 성다연 on 2020/06/06.
//  Copyright © 2020 홍정민. All rights reserved.
//

import UIKit

class ImageCropVC: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cropView: UIView!
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtn(_ sender: UIButton) { nextVC() }
    
    var layoutImageView : UIImageView = UIImageView()
    var layoutCustomSize : CGFloat = CGFloat()
    var layoutRatio : CGFloat = CGFloat()
    
    var image : UIImage!
    var imageRadio : CGFloat = CGFloat()
    var selectedLayout : AlbumLayout! = .Polaroid
    var albumUid : Int = 0
    var imageName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetting()
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//
//        if touch?.view == layoutImageView {
//            let position = touch!.location(in: self.view)
//            let target = layoutImageView.center
//            let size = max((position.x / target.x), (position.y / target.y))
//            let scale = CGAffineTransform(scaleX: size, y: size)
//            layoutCustomSize = size
//            layoutImageView.transform = scale
//        }
//    }
    
}
 

extension ImageCropVC {
    private func layoutSetting(){
        layoutRatio = min(layoutImageView.frame.width / layoutImageView.frame.height,
                                 layoutImageView.frame.height / layoutImageView.frame.width)
        imageRadio = min(image.size.width / image.size.height,
                                image.size.height / image.size.width)
        photoImageView.image = image.resizeImage(image: image, newSize: CGSize(width: image.size.width, height: image.size.height))
        
        layoutImageView = UIImageView(image: selectedLayout.cropImage)
        layoutImageView.isUserInteractionEnabled = true
        layoutImageView.frame.size = iPhone8Model() ? selectedLayout.innerFrameLowSize : selectedLayout.innerFrameHighSize
        layoutImageView.center = cropView.center
        
        // 1. 이미지 크기를 모름
        // 2. 이미지 비율을 알아서 이미지 크기를 view width or height 에 맞춤
        // 3. 레이아웃 이미지를 이미지 크기에 맞춤
        // 4. 이미지 자름
        print("image size = \(imageRadio), \(photoImageView.image?.size)")
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        layoutImageView.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinchGesture:)))
        layoutImageView.addGestureRecognizer(pinchGesture)
        self.cropView.addSubview(layoutImageView)
    }
    
    private func nextVC(){
        let croppedCGImage = photoImageView.image?.cgImage?.cropping(to: layoutImageView.frame)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        print("cropped image frame = \(croppedImage.size)")
        image = croppedImage
        
        if image != nil {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "imageRenderVC") as! ImageRenderVC
            
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.image = image
            nextVC.selectLayout = self.selectedLayout
            nextVC.albumUid = self.albumUid
            nextVC.imageName = self.imageName
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


extension ImageCropVC {
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer){
        let transtition = panGesture.translation(in: self.view)
        panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + transtition.x, y: panGesture.view!.center.y + transtition.y)
        panGesture.setTranslation(.zero, in: self.view)
    }
    @objc private func handlePinchGesture(pinchGesture : UIPinchGestureRecognizer){
        pinchGesture.view?.transform = (pinchGesture.view?.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale))!
        pinchGesture.scale = 1.0
    }
}


class CropAreaView: UIImageView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
